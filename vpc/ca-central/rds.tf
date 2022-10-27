


/// Creates subnet group for the RDS instance 

resource "aws_db_subnet_group" "shola" {
  name       = var.rds_name
  subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.private_subnet2.id]

  tags = {
    Name = "shola"
  }
}



resource "aws_security_group" "rds" {
  name   = var.rds_name
  vpc_id = aws_vpc.videri_vpc.id

  ingress {
    from_port   = var.rds_port
    to_port     = var.rds_port
    protocol    = var.rds_protocol
    cidr_blocks = [var.public_cidr_block]
  }

  egress {
    from_port   = var.rds_port
    to_port     = var.rds_port
    protocol    = var.rds_protocol
    cidr_blocks = [var.cidr_blocks]
  }

  tags = {
    Name = "shola_rds"
  }
}

resource "aws_db_parameter_group" "shola" {
  name   = var.rds_name
  family = var.family_parameter

  parameter {
    name  = var.log_name
    value = var.parameter_value
  }
}

resource "aws_db_instance" "shola" {
  db_name                = var.db_name
  identifier             = var.rds_name
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  username               = var.rds_name
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.shola.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.shola.name
  publicly_accessible    = var.public_access
  skip_final_snapshot    = true
  storage_encrypted      = true
}


# initial password
resource "random_password" "db_password" {
  length           = 16
  special          = true
  min_special      = 5
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}


resource "random_id" "id" {
  byte_length = 15
}


# the secret
resource "aws_secretsmanager_secret" "db-pass" {
  name = "db-pass-${random_id.id.hex}"
}

# initial version
resource "aws_secretsmanager_secret_version" "db-pass-val" {
  secret_id = aws_secretsmanager_secret.db-pass.id
  # encode in the required format
  secret_string = jsonencode(
    {
      username = aws_db_instance.shola.username
      password = aws_db_instance.shola.password
      engine   = var.engine
      host     = aws_db_instance.shola.endpoint
    }
  )
}
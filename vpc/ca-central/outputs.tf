output "vpc_id" {
  value = aws_vpc.videri_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "private_subnet2_id" {
  value = aws_subnet.private_subnet2.id
}

output "aws_internet_gateway_id" {
  value = aws_internet_gateway.videri_gw.id
}




output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.shola.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.shola.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.shola.username
  sensitive   = false
}

/// EC2
output "ami_id" {
  value = data.aws_ami.videri_ami.id
}

output "ec2_private_ips" {
  value = ["${aws_instance.bastion_host.*.private_ip}"]
}

output "ec2_global_ips" {
  value = ["${aws_instance.bastion_host.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.bastion_host.*.public_dns}"]
}

output "rds_endpoint" {
  value = aws_db_instance.shola.endpoint
}


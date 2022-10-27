/// EC2 INSTANCE AND EBS ATTACHMENT ///

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.bastion_host.id
}

resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.videri_ami.id
  instance_type               = var.instance_type
  associate_public_ip_address = var.public_ip_address

  subnet_id              = aws_subnet.public_subnet.id
  user_data              = file("${path.module}/userdata.sh")
  availability_zone      = var.availability_zone_a
  vpc_security_group_ids = [aws_security_group.videri_sg.id]

  tags = {
    Name = "Bastion-Host"
  }
}

resource "aws_ebs_volume" "ebs" {
  availability_zone = var.availability_zone_a
  size              = 1
}




/// KEY PAIR ///

resource "aws_key_pair" "videri_key" {
  key_name   = var.key_name
  public_key = file(var.key_pair)

}
### key pair (using local public key) ###
resource "aws_key_pair" "my_key_pair" {
  key_name   = var.key_name
  public_key = file("my-key.pub") # Ensure this path points to your actual public key
}

### Ec2 Instance ####
resource "aws_instance" "BackendServer" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private.id
  associate_public_ip_address = false
  vpc_security_group_ids = [ aws_security_group.ec2_sg.id ]
  key_name = aws_key_pair.my_key_pair.key_name
  tags = {
    Name = "BackendServer"
  }

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install docker.io -y
                sudo systemctl start docker
                sudo systemctl enable docker
                EOF
}

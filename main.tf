provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "tf-server-01" {
  ami           = "ami-0c80e2b6ccb9ad6d1"
  instance_type = "t2.micro"
  tags = {
    Name = "Terraform-Instance-01"
  }
  security_groups = [aws_security_group.allow_sujit.id]
  lifecycle {
   create_before_destroy = true
   ignore_changes = [
      security_groups,
   ]
  }
  user_data = <<-EOF
         #!/bin/bash
         #update yum
         yum update -y
         #Install httpd 
         yum install -y httpd 
         #Start HTTPd
         systemctl enable httpd
         systemctl start httpd
         EOF
}

resource "aws_security_group" "allow_sujit" {
  name          =  "allow_raguh"
  description   = "SG for allowing SSH Access"
  ingress {
    from_port  = 22
    to_port    = 22
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
     from_port  =  80
     to_port    = 80
     protocol  = "tcp"
     cidr_blocks  = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

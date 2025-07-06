provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2, update if needed
  instance_type = "t2.micro"
  key_name      = "YOUR_KEY_PAIR_NAME"

  tags = {
    Name = "HelloWorldServer"
  }

  provisioner "remote-exec" {
    inline = ["sudo yum update -y"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = "YOUR_KEY_PAIR_NAME"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
}

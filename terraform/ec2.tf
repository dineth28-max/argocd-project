  
  resource "aws_instance" "new_in_tf_ubuntu" {
    ami                         = "ami-08d59269edddde222"
    instance_type               = "m7i-flex.large"
    region = "us-east-1"
    associate_public_ip_address = true
    key_name                    = "delete"
    subnet_id                   = "subnet-02cd5d28c2ae7dc56"
    vpc_security_group_ids      = [aws_security_group.allow_tls.id]
    
    user_data = file("install.sh")
    
    
    user_data_replace_on_change = true
    root_block_device {
      volume_size = 40
    }

    tags = {
      Name = "My-Ubuntu-Instance-cit-24-01-0396"
    }
  }

  resource "aws_security_group" "allow_tls" {
    name        = "allow_tls"
    description = "Allow TLS inbound traffic and all outbound traffic"
    vpc_id      = aws_vpc.vpc_tf.id

    tags = {
      Name = "Project SG"
    }
    ingress {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "Http"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
      description = "Https"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
        ingress {
      description = "default"
      from_port   = 8080
      to_port     = 8080
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
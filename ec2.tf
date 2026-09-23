resource "aws_instance" "SonarQube" {
  ami           = "ami-0b6d9d3d33ba97d99" # Ubuntu Server 26.04 LTS (x86)
  instance_type = "t3.medium" # Change to "t3.large" if SonarQube runs low on memory
  user_data = file("sonar.sh")

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "SonarQube"
    Project = "SonarQube-server"
  }
}



resource "aws_security_group" "allow_sonarqube" {
  name        = "allow-sonarqube-traffic"
  description = "Allow SonarQube (9000), SSH (22) inbound and all outbound traffic"

  # Outbound rule: Allow all traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Inbound rule: SonarQube Web UI (Port 9000)
  ingress {
    description      = "SonarQube Web UI"
    from_port        = 9000
    to_port          = 9000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Inbound rule: SSH Access (Port 22)
  ingress {
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-sonarqube-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}
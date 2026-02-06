resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-ec2-sg"
  description = "Security group for WordPress EC2"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

resource "aws_instance" "wordpress" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI - actualiza según tu región
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_ids[0]
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
              yum install -y httpd mariadb-server
              systemctl start httpd
              systemctl enable httpd
              cd /var/www/html
              wget https://wordpress.org/latest.tar.gz
              tar -xzf latest.tar.gz
              cp wordpress/wp-config-sample.php wordpress/wp-config.php
              sed -i 's/database_name_here/${var.db_name}/' wordpress/wp-config.php
              sed -i 's/username_here/${var.db_username}/' wordpress/wp-config.php
              sed -i 's/password_here/${var.db_password}/' wordpress/wp-config.php
              sed -i 's/localhost/${var.db_host}/' wordpress/wp-config.php
              cp -r wordpress/* /var/www/html/
              chown -R apache:apache /var/www/html/
              chmod -R 755 /var/www/html/
              EOF

  tags = {
    Name = "${var.project_name}-wordpress"
  }
}
provider "aws" {
  region = "ap-south-1"
}

//Dynamic Block used for ports (80 and 443 HTTP and HTTPS)

variable "ingress" {
  type = list(number)
  default = [ 80, 443 ]
}

variable "egress" {
  type = list(number)
  default = [ 80,443 ]
}

// Creation of db Server
resource "aws_instance" "dbInstance" {
  ami = "ami-041d6256ed0f2061c"
  instance_type = "t2.micro"

  tags = {
      Name = "dbInstance"
  }
}

//Creation of Web Server
resource "aws_instance" "webServerInstance" {
  ami = "ami-041d6256ed0f2061c"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_traffic.name]
   user_data = file("server-script.sh")                        // running script file 

  tags = {
      Name = "WebInstance"

  }
}

// Fixed Public IP for Web Server
resource "aws_eip" "web_eip" {
  instance = aws_instance.webServerInstance.id
}

// Creation of SG for Web Server
resource "aws_security_group" "web_traffic" {
  name = "web_traffic"
  description = "Allow to access through IP"

  dynamic "ingress" {
      iterator = port
      for_each = var.ingress
      content   {
                    from_port = port.value
                    to_port = port.value
                    protocol = "TCP"
                    cidr_blocks = ["0.0.0.0/0"]
                 }
  }

  dynamic "egress" {
      iterator = port
      for_each = var.egress
      content   {
                    from_port = port.value
                    to_port = port.value
                    protocol = "TCP"
                    cidr_blocks = ["0.0.0.0/0"]
                 }
  }
  tags = {
    "Name" = "web_traffic"
  }
}

// Output PrivateIP for db server
output "PrivateIP" {
  value = aws_instance.dbInstance.private_ip
}

// Output PublicIP for Web Server
output "PublicIP" {
  value = aws_eip.web_eip.public_ip
}
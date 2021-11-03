#!/bin/bash
sudo yum update                     # Update the system
sudo yum install -y httpd           # Install Apache
sudo systemctl start httpd          # Start Apache
sudo systemctl enable httpd         # Enable The Server

echo "<h1>Hello from Terraform</h1>" | sudo tee /var/www/html/index.html
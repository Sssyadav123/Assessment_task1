Automating AWS Infrastructure Deployment with Terraform: Step-by-Step Guide

In today’s cloud-first world, automating infrastructure deployment is no longer a luxury—it’s a necessity. For developers and DevOps engineers, Terraform has become one of the go-to tools for managing cloud resources with Infrastructure as Code (IaC).

In this blog, we’ll walk through a hands-on example of deploying an AWS EC2 instance with NGINX using Terraform. Along the way, we’ll:

✅ Launch an EC2 instance in AWS
✅ Install and configure NGINX automatically
✅ Serve a custom HTML page
✅ Secure the instance with a custom Security Group

Let’s dive in! 🚀

Prerequisites

Before you begin, make sure you have:

An AWS account

Terraform installed locally

An SSH key pair to access the EC2 instance

Step 1: Defining the Terraform Configuration

Our main configuration file (main.tf) will describe everything Terraform needs to build.

AWS Provider Configuration

We’ll specify the AWS region and profile:

provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}

Launching an EC2 Instance

We’ll spin up a t2.micro Ubuntu instance (free-tier eligible) with a startup script that installs NGINX:

resource "aws_instance" "aws_ubuntu" {
  instance_type = "t2.micro"
  ami           = "ami-0d682f26195e9ec0f"
  user_data     = file("commands.tpl")
}

Default VPC

To simplify networking, we’ll launch the instance in the default VPC:

resource "aws_default_vpc" "default" {}

Security Group

We’ll create a security group to allow SSH (22) and HTTP (80) traffic:

resource "aws_security_group" "task1_sg" {
  name        = "demo_sg"
  description = "allow ssh on 22 & http on port 80"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

Step 2: Automating NGINX Installation

The startup script (commands.tpl) will install NGINX, configure a custom HTML page, and start the service:

#!/bin/bash -ex
amazon-linux-extras install nginx1 -y
echo "<h1>Deployed via Terraform</h1>" > /usr/share/nginx/html/index.html
systemctl enable nginx
systemctl start nginx

Step 3: Managing Sensitive Information

Store sensitive details like AWS credentials and SSH key paths in terraform.tfvars:

aws_access_key    = "your_aws_access_key"
aws_secret_key    = "your_aws_secret_key"
key_name          = "First_key"
private_key_path  = "Downloads/First_key.pem"

Step 4: Tracking Infrastructure State

Terraform uses terraform.tfstate and terraform.tfstate.backup files to track the current infrastructure state. This allows it to know what’s deployed and what changes to apply.

Step 5: Outputting the Public DNS

To quickly access our instance, we’ll define an output in outputs.tf:

output "aws_instance_public_dns" {
  value = aws_instance.aws_ubuntu.public_dns
}


After deployment, this will display the instance’s public DNS in your terminal.

Deploying the Infrastructure

Now let’s bring everything to life:

Initialize Terraform

terraform init


Plan the Deployment

terraform plan


Apply the Configuration

terraform apply


(Confirm when prompted ✅)

Step 6: Accessing Your NGINX Server

Once Terraform finishes, copy the public DNS from the output and visit:

http://<public_dns>


You should see:

<h1>Deployed via Terraform</h1>


🎉 Congratulations! You’ve just automated the deployment of an AWS EC2 instance running NGINX with a custom webpage—all using Terraform.

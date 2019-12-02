# Production-Grade Terraform Code

Modules should be small. Previously webserver-cluster module was to big and had a few different parts.
  * Three parts:
    + Auto Scaling Group (ASG): 
      - modules/cluster/asg-rolling-deply
    + Application Load Balancer (ALB): 
      - modules/networking/alb
    + Hello, World app: 
      - modules/services/hello-world-app

> If you `terraform apply` with version 0.12.0 and someone comes along and `terraform apply` with 0.12.1 the state file will no longer work with 0.12.0 and all those machines will need an update.

Code for small modules not shown in this folder, since almost done with book will have a FINAL directory with FINAL code repo.

# SSH into EC2 instance

```
resource "aws_security_group" " instance" {
    ingress { 
        from_port = 22
        to_port = 22
        protocol = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Automatically generate a private key
resource "tls_private_key" "example {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "generated_key" {
    public_key = tls_private_key.example.public_key_openssh
}

resource "aws_instance" "example" {
    ami = ...
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]
    # -->> Load ec2 instance with bulic key to server's authorized_keys file
    key_name = aws_key_pair.generated_key.key_name
}
```



# Skimmed Pages
#208-220

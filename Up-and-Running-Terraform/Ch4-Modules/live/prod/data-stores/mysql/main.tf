provider "aws" {
    region = "us-east-2"
}

resource "aws_db_instance" "example" {
    identifier_prefix = "terraform-up-and-running"
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t2.micro"
    name = var.db_name
    username = "admin"

    # How should we set the password?
    password = data.aws_secretsmanager_secret_version.db_password.secret_string

}

data "aws_secretsmanager_secret_version" "db_password" {
    secret_id = "mysql-master-password-prod"
}


terraform {
    backend "s3" {
        key = "prod/data-stores/mysql/terraform.tfstate"
    }
}
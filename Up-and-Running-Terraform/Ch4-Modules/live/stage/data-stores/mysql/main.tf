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
    skip_final_snapshot = true

    # How should we set the password?
    #password = data.aws_secretsmanager_secret_version.db_password.secret_string
    password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["secret_string"]

}

data "aws_secretsmanager_secret_version" "db_password" {
    secret_id = "ryanharlich-mysql-master-password-stage"
}


terraform {
    backend "s3" {
        key = "stage/data-stores/mysql/terraform.tfstate"
    }
}
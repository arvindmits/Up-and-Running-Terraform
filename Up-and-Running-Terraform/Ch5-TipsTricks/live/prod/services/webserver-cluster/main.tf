provider "aws" {
    region = "us-east-2"
}

module "webserver_cluster" {
    source = "../../../modules/services/webserver-cluster"

    cluster_name = var.cluster_name
    db_remote_state_bucket = var.db_remote_state_bucket
    db_remote_state_key = var.db_remote_state_key

    instance_type = "t2.mirco" # Normally for production would be better
    min_size = 2
    max_size = 6
    enable_autoscaling = false
}

terraform {
    backend "s3" {
        key = "prod/services/webserver-cluster/terraform.tfstate"
    }
}
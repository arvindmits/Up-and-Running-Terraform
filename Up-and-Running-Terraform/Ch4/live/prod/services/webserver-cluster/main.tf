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
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
    schedule_action_name = "scale_out_during_business_hours"
    min_size = 2
    max_size = 10
    desired_capacity = 10
    recurrence = "0 9 * * *"

    autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
    schedule_action_name = "scale_in_at_night"
    min_size = 2
    max_size = 10
    desired_capacity = 2
    recurrence = "0 17 * * *"

    autoscaling_group_name = module.webserver_cluster.asg_name
}

terraform {
    backend "s3" {
        key = "prod/services/webserver-cluster/terraform.tfstate"
    }
}
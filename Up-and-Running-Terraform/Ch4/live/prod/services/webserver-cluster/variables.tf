/*****************************************************************************
*    Required Variable
******************************************************************************/
variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket used for the database's remote state storage"
  type        = string
}

/*****************************************************************************
*    Optional Variable
******************************************************************************/
variable "cluster_name" {
  description = "The name to use to namespace all the resources in the cluster"
  type        = string
  default     = "webservers-prod"
}

variable "db_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the database's remote state storage"
  type        = string
  default = "prod/data-stores/mysql/terraform.tfstate"
}

/*****************************************************************************
*    Required/Optional Variable
******************************************************************************/
variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default = "terraform-up-and-running-state-ryan-harlich"
}

variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default = "terraform-up-and-running-locks"
}
Limitations with Terraform's Backends "chicken-and-egg situation":
  + Two step process creation process - (1) You have to write code to create S3 bucket and DynamoDB table then deploy. (2) Afters going back to implement backend configuration to use your newly created resources and run `terraform init`.
  +  Two step delete process - (1) Remove backend configuration and run `terraform init` to copy Terraform state back to local disk. (2) Run `terraform destroy` to delete S3 bucket and DynamoDB table. For step (1) you might need to do this `terraform init -lock=false`. Not sure how I feel about this. Step (2) does not even work because the bucket has to be empty

Also, can't use variables in backend block. Solution:
  + Make a `backend.hcl` file with variables and run `terraform init -backend-config=backend.hcl`.
  + Use Terragrunt which an example is provided in Chapter 8 and helps backend configuration be DRY.


  ## Isolation Via WORKSPACES

`terraform workspace show` shows which workspace in

`terraform workspace new <name>` creates new workspace & switch to

`terraform workspace list` show all workspaces

`terraform workspace select <name>` select an existing workspace

`terraform workspace delete <name>` delete an existing workspace if statefile is destroyed first

workspaces get stored in s3 under folder `env:`

workspaces are for experimentation, try the following to do cheap test on another workspce:
instance_type = terraform.workspace == "default" ? "t2.medium" : "t2.micro"

Workspaces are very error prone! Use Isolation Via File Layout instead.


To destroy default workspace without deleting S3 and DynamoDB resources you have to use -target flag in destroy. This is a problem and only works on small scales.
https://github.com/hashicorp/terraform/issues/16392

To avoid destroying S3 and DynamoDB resources run:
`terraform destroy -target=aws_instance.example`

## Isolation Via File Layout

Refer to isolated directory, nonisolated is prior to this section.

If you lead export by a space you prevent secret from being stored in bash history 
> `$ export TF_VAR_db_password="(YOUR_DB_PASSWORD)"`

`terraform console` is a read-only console so you can't mess anything up

This section was not deployed because it is very badly structured. Waiting for module chapter or next chapter.

Quick things covered.
  + `data.terraform_remote_state.<NAME>.outputs.<ATTRIBUTE>`: which is all the database's output variables are stored in the state file and you can read them from the terraform_remote_state data source using an attribute reference of this form.
  + Avoiding Bash scrips inline with `data "template_file" "<name>" {template = file("user-data.sh") ... vars = {server_port = var.server_port}}` check out user-data.sh in stage > servers > webserver-cluser > user-data.sh
  + RDS and password management with password = `data.aws_secretsmanager_secret_version.db_password.secret_string`


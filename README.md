# Prerequisites

> $ export AWS_ACCESS_KEY_ID="anaccesskey"
> $ export AWS_SECRET_ACCESS_KEY="asecretkey"
> $ terraform init

OR

Run "aws configure" where credentials will be stored here:
"/Users/<username>/.aws/credentials" or $HOME/.aws/credentials


## Tips

\+ means created
\- means deleted
~ means modified
-/+ means replace

Listening on ports less than 1024 requires root user privileges
  + port 80, HTTP
  + port 443, HTTPS

Production use private subnets not Default VPC which is public subnets
  + Reverse proxies and load balancers that are locked down as much as possible do use public subnets though

"${...}" is an interpolation used in string literal
  + No quotes for bash script with EOF


By default all AWS resources don't allow incoming or outgoing traffic, so need to create security group

ARN = Amazon Resource Name

DRY (Don't Repeat Yourself)



> Terraform init
> Terraform refresh - TF View -> Real world: What is actually running?
> Terraform plan - Real world -> desired config
> Terraform apply - plan -> real world
> Terraform destroy - plan -> real world

Can also append `-auto-approve` to avoid typing in yes. Not the safest route though.


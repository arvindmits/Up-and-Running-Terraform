# Modules

When module is added MUST run `terraform init` to include module


New covered concepts (to me):
  + local variables
  + aws_autoscaling_schedule/output variables
  + Gotchas (1): File paths
    + path.module = returns filesystem path of the module where the expression is defined
    + path.root = returns filesystem path of the root module
    + path.cwd = basically same as path.root except for advanced uses of Terraform where current working directory might be somewhere else
  + Gotchas (2): Inline Blocks - Don't have inline like in aws_security_group ingress and egress. Make seperate aws_security_group_rule resources for this. Combining both inline blocks and separate resources will result in errors.


> IMPORTANT: A Hacker could hack into your staging then get into production with how things are set up currently. Solution: Run stage and prod in different VPC or different AWS accounts!

# Skimmed Module Versioning

Basically do the following:
  1. Git init in Modules and push.
  2. `git tag -a "v0.0.1" -m "First release of webserver-cluster module"; git push --follow-tags`
  3. In stage or prod when using module change source to be `source = "git@github.com:<OWNER>/<REPO>.git//<PATH>?ref=v0.0.1"` if private repo otherwise if public this is fine `source = "github.com/<OWNER>/<REPO>//<PATH>?ref=v0.0.1"`
  4. Rerun `terraform init`

v0.0.0 = MAJOR.MINOR.PATCH
  + MAJOR = version when you make incompatible API changes
  + MINOR = version when you add functionality in a backward-compatible manner
  + PATCH = version when you make bckward-compatible bug fixes


# TO RUN FROM SCRATCH

1. Run `terraform init` and `apply` in Live > Global > s3 to get the backend ready.
2. Go to live > stage > data-stores > mysql. 
  + Run `terraform init -backend-config=../../../global/s3/backend.hcl`
  + Create secret in AWS Secret Manager
    + Choose Other type of secrets
    + Add two rows for key/value
      + Row 1: secret_id | <data "aws_secretsmanager_secret_version" secret id name>
      + Row 2: secret_string | <8+ character password>
    + Secret name: <data "aws_secretsmanager_secret_version" secret id name>
    + No rotation and review and submit
  + `terraform apply`
3. Go to live > stage > services > webserver-cluster.
  + `terraform init -backend-config=../../../global/s3/backend.hcl`
  + `terraform apply` for S3 bucket name copy and paste from global/s3/backend.hcl assuming it is the same used in global/s3/variables.tf

> IMPORTANT NOTE: For the mysql `terraform apply` if any steps don't work after that I added `skip_final_snapshot = true` for destroying and did not test. This can be found in stage > data-stores > mysql > main.tf. If problems try commenting out and uncommenting for destroying.

## Test

Run in browser: http://<output from apply from alb_dns_name>
  + e.g., http://webservers-stage-#########.us-east-2.elb.amazonaws.com

## To Destroy

1. Go to live > stage > services > webserver-cluster
  + `terraform destroy` for S3 bucket name copy and paste from global/s3/backend.hcl assuming it is the same used in global/s3/variables.tf
2. Go to live > stage > data-stores > mysql. 
  + `terraform destroy`
3. Go to live > global > s3.
  + `terraform destroy`
    + Note: You can't delete, you can comment out lifecycle {prevent_destroy = true} for s3 resource to delete DynamoDB table, but you will still not be able to delete because bucket is not empty. So manually delete since it is only one bucket.



# DONE!

Prod should be the same; although I never tested this.
  
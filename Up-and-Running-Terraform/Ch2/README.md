Up until LoadBalancer run:
  + curl http://<ipaddress>:8080
At LoadBalancer run:
  + curl http://<alb_dns_name>

# For ConfigurableWebServer

With no default value for variable you can:
  + Terraform will interactively prompt user to enter a value
  + terraform plan -var "server_port=8080"
  + Environment variable
    + export TF_VAR_server_port=8080
    + terraform plan

"terraform output" or "terraform output <output_name>" will list output(s)

# For ClusterofWebServers

Terraform won't be able to delete resource if change parameter of launch configuration because ASG now has a reference to the old resource and it will try to replace resource.
  * Solution: use a lifecycle setting like create_before_destroy = true. This works because it won't try to replace resource and will create first and pointers will point to replacement which can then delete old resource

# Cluster -> LoadBalancer

Problem with Cluster is you have multiple IP address, but you only want to give user one IP address. 
  * Solution: LoadBalancer (you give users DNS name not IP of LoadBalancer)

# For LoadBalancer

  + Amazon's Elastic Load Balancer (ELB) service
    - Types:
        * Application Load Balancer (ALB): For HTTP and HTTPS traffic (operates at the application layer (Layer 7) of the OSI model)
        * Network Load Balancer (NLB): For TCP, UDP, and TLS traffic (operates at the transport layer (Layer 4) of the OSI model)
        * Classic Load Balancer (CLB): "legacy" all of the above with fewer features. Best not to use.


ALB consist of: Listeners, Listener Rules, Target Group

resource "aws_autoscaling_group" "example" {
    ...
    health_check_type = "ELB"

  Important: This is set to "EC2" by default. Set to "ELB"


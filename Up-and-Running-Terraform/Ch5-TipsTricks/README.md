# Loops

## count parameter

```
variable "user_names" {
    desctiption = "Create IAM users with these names"
    type = list(string)
    default = ["neo", "trinity", "morpheus"]
}
```

```
resource "aws_iam_user" "example" {
    count = length(var.user_names)
    name = var.user_names[count.index]
}
```

example is now an array so access by `output "neo_arn" {value = aws_iam_user.example[0].arn}`

or all by doing `value = aws_iam_user.example[*].arn` note the *

#### Limitations

+ Count not support in inline blocks
+ Deleting trinity will rename trinity to morpheus and delete morpheus because it is an array so it gets shifted rather

Solution as of Terraform 0.12: for_each expressions

## for_each expressions

```
resource "aws_iam_user" "example" {
    for_each = toset(var.user_names)
    name = each.value
}

output "all_users" {
    value = aws_iam_user.example
}

output "all_arns" {
    value = values(aws_iam_user.example)[*].arn
}
```

#### For inline

```
variable "custom_tags" {
    type = map(string)
    default = {}
}

module "webserver_cluster" {
    source ...
    ...

    custom_tags = {
        Owner = "team-foo"
        DeployedBy = "terraform"
    }
}

resource "aws_autoscaling_group" "example" {
    ...

    tag {
        ...
    }

    dynamic "tag" {
        for_each = var.custom_tags

        content {
            key = tag.key
            value = tag.value
            propagate_at_launch = true
        }
    }
}
```

> USE FOR_EACH EXPRESSIONS OVER COUNT

## for expressions

```
variable "user_names" {
    desctiption = "Create IAM users with these names"
    type = list(string)
    default = ["neo", "trinity", "morpheus"]
}
```

Like Python comprehension Terraform offers `for expressions`

> [for \<ITEM> in \<LIST> : \<OUTPUT>]

```
output "upper_names" {
    value = [for name in var.names : upper(name)]
}

#plus filter
output "upper_names" {
    value = [for name in var.names : upper(name) if length(name) < 5]
}
```

> [for \<KEY>, \<VALUE> in \<MAP> : \<OUTPUT>]

```
variable "hero_thousand_faces" {
    type = map(string)
    default = {
        neo = "hero"
        trinity = "love interest"
        morpheus = "mentor"
    }
}

output "bios" {
    value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
}

```

 Loop over a list and output a map
> [for \<KEY>, \<VALUE> in \<MAP> : \<OUTPUT_KEY> => \<OUTPUT_VALUE>]

 Loop over a map and output a map
> [for \<KEY>, \<VALUE> in \<MAP> : \<OUTPUT_KEY> => \<OUTPUT_VALUE>]

## for string directive

for-loops
```
output "for_directive" {
    value = <<EOF
%{~ for name in var.names}
    ${name}
%{~ endfor}
EOF
}
```

```
value = "Hello, %{if var.name != ""}${var.name}%{else}(unamed)%{endif}"
```


# Conditions

Moved the following to module and set enable_autoscaling to true for prod and false for stage

```
resource "aws_autoscaling_schedule" "scale_in_at_night" {
    count = var.enable_autoscaling ? 1 : 0
    ...
}
```

> count = format("%.1s, var.instance_type) == "t" ? 1 : 0

# Zero-Downtime Deployment

In AWS_Autoscaling_Group resource
  + Configure name parameter of ASG to depend directly on the name of launch configuration. This forces Terraform to replace ASG when ASG's name changes.
  + Add create_before_destroy parameter -> creates ASG before destroying original
  + Min_elb_capacity parameter added to be min_size. --> Terraform will wait for this many servers to be healthy before destroying original ASG.

# Gotchas

For_each loops and count can only used hardcoded values not output or resources such as `random_integer`.

`terraform import`
`terraform state`



> NOTE: I did not add these changes to code. I am switching to using the author's code periodically to avoid deploying each time as the usuage is going up and also the pieces are no longer whole, but instead bits and pieces.
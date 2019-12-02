# WORKING WITH A TEAM

+ Branching does not make sense with terraform because if two different people apply two different changes from different branches the second person will undo the changes of the first person.

+ Provide a readme for modules. Explaining how to use them.

+ `terraform fmt` formats code to team's likings.

+ Always do `plan` before `apply`. 
> IMPORTANT: `terraform plan -out=example.plan` be careful of because it could have secrets!!!

+ pg. 297 for application code not IaC.

+ pg. 316 `terragrunt`
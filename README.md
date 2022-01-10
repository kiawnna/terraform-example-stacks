# Example Terraform Stacks
This repo contains example terraform stacks for common use-cases (like auto-scaled, load-balanced, EC2s and containerized apps hosted on
ECS), all with secure, best-practice networking in place. The stacks will use publicly available, opinionated and customizable modules, which are available as standalone 
repos as well.

## Variables
Each example repo will have instructions for deploying it, as well as a `dev.tfvars` file. The variables in this file are the only required ones to launch the stack.
To declare more variables or change settings, you will need to go the module-specific repo or investigate the code further. New stack variables can be added to the 
`variables.tf` file.

## Note
It is important to note that these stacks will launch resources into your account that may cost money.

See each stack repo for a `readme` with more specific information and instructions.
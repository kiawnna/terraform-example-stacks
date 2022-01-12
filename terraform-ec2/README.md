# terraform-ec2-stack
This stack will launch a best-practice, secure, networking along with auto-scaled, load-balanced EC2 instances and all
necessary resources for Route53 as well.

The variables in `dev.tfvars` are the only required variables needed to launch this stack. You can customize as needed.

Below is a diagram of the infrastructure that will be deployed into your account:

![EC2 Stack](/terraform-ec2/EC2_Stack_Diagram.png)

## Shared resources
Shared resources are resources that will only be deployed once per environment and are shared amongst the applications you
launch. These resources include:

* Networking resources, with best-practice security and high-availability in mind:
    - VPC
    - Two public and two private subnets, in different availability zones
    - A public and private route table
    - An internet gateway and NAT gateway
    - A bastion instance, for access to private instance
    - Security groups:
        * One for the bastion instance, which allows only SSH traffic
        * One for the load balancer, which allows traffic over port 443 and port 80
        * One for the private EC2 instances, which allows traffic from the load balancer and bastion's security groups
    
* Load-balancing resources
    - Application load balancer
    - Two listeners, one for http and one for https traffic
    
* Auto-scaling resources
    - An autoscaling group to mange EC2 instances
    - A launch template for the EC2 instances

## Per applications resources
Per application resources include the resources that will be launched for each application you need deployed. The
`applications` variable contains a map of information about applications. Adding to this map will deploy the following
resources for each application in the map:

* A target group
* A Route 53 record
* A listener rule, to direct traffic from the correct route 53 record

These three resources will be automatically integrated with the shared networking and other resources automatically.

For a specific list of resources, visit each of the modules repos and read through the `readme` provided there.

## Deploying
To deploy this stack, first update the values in the `dev.tfvars` file to suite your needs:

* environment &rarr; Environment. Common values are `dev`, `stage`, and `prod`.
* region &rarr; The AWS region you want to deploy to.
* key_pair &rarr; The key pair to create your bastion and private instances with.
* load_balancer_cert_arn &rarr; The certificate arn for your load balancer's https listener to use.
* applications &rarr; A map of any number of applications to deploy. See the `dev.tfvars` file for an example. Each
  application will need an `app_name`, `port`, `certificate_arn`, `hosted_zone_id`, and `domain`.
  
Next, run `terraform get` to get the modules needed.
> Note: If you ever need to update these modules, you will need to run: `terraform get -update`.

Run `terraform init`.

Run `terraform apply -var-file="dev.tfvars"`. Replace the name of the file with whichever file you create to store your
variables in.

That's it!

## Destroying
To destroy your stack, run: `terraform destroy -var-file="dev.tfvars"`.
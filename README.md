# terraform-lib
Some terrafrom modules for AWS I share between my projects.

## ssh-key
Creates ssh key pair from current user `.ssh/id_rsa.pub` so you can just do
`ssh ubuntu@new_machine_ip`.

###Variables

* project - name of the project. It becomes the key name 

## vpc
Creates VPC with one subnet
###Variables
* project
* region 

### TODO
* Get rid of provider and region variable

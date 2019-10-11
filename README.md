# terraform-lib
Some terrafrom modules for AWS I share between my projects.

## ssh-key
Creates ssh key pair from current user `.ssh/id_rsa.pub` so you can just do
`ssh ubuntu@new_machine_ip`.

### Variables

* project - name of the project. It becomes the key name 

## vpc
Creates VPC with one subnet
### Variables
* project

## xenial
Finds Ubuntu Xenial AMI id

### Outputs
* id

Creates DNS records

### variables
* doamin
* hostname
* address

### outputs
* fqdn

## TODO:
* [ ] provision
* [ ] Add EIP to host

## Nice to have / ideas
* ssh-key adds default username to ssh options. We can as well setup non default key.

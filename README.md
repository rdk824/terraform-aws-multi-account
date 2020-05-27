# Terraform AWS multi-account

Terraform code which automates the deployment of AWS resources in a multi-account environment.


## Goals

The goal of this project is to make it easy to deploy new AWS resources in AWS Organizations sub-accounts using the same Terraform code while keeping the code DRY. 

## Project Structure

```bash
├── Makefile
├── environments
│   ├── networking
│   │   ├── development.tf
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── production.tf
│   │   ├── provider.tf
│   └── root
│       ├── main.tf
│       ├── outputs.tf
│       ├── provider.tf
├── resources
│   ├── compute
│   ├── containers
│   ├── networking
│   ├── security
│   └── storage
├── scripts
│   ├── read_cfg.sh
│   ├── set_vars.sh
│   └── tf_remote_state.sh
```

## Usage


### Root account and member accounts

The code is configured by default to deploy in:

- **root**: Master/root account where users access is defined. No resources are deployed here.
- **development**: Development environment       
- **production**: Production environment

These accounts name can be modified.

### Configure awscli

Use `aws configure` to set up credentials manually edit:

- *~/.aws/credentials*
```shell
[default]
aws_access_key_id = access_key_id
aws_secret_access_key = secret_access_key
```

and

- *~/.aws/config*
```bash
[profile default]
region = us-east-1
output = json
```

The automation scripts read `~/.aws/config` to get the *region* and *output* format.

### AWS Profile
You need to add `AWS_PROFILE := profile_name` in [Makefile](https://github.com/rdansou/terraform-aws-multi-account/blob/master/Makefile) or run `export AWS_PROFILE=profile_name` if you're using a profile name different from `default`.

### How to deploy a resource?
Let's assumes that you want to deploy [Network resources](https://github.com/rdansou/terraform-aws-multi-account/tree/master/resources/networking) in production.

1. Provide terraform variables in [production networking file](https://github.com/rdansou/terraform-aws-multi-account/blob/master/environments/networking/production.tf)
2. Then from the root of the project run:
```bash
make tf_apply ENV="production" RESOURCE="networking"
```

This command will:
- set Terraform workspace to production
- create an S3 bucket and a DynamoDB table for Terraform remote state if not created yet in Root account
- create a *terraform.tf* file that contains Terraform remote state configuration in the environment [networking folder](https://github.com/rdansou/terraform-aws-multi-account/tree/master/environments/networking)
- create a *variables.tf* file that contains variables needed to set up the provider for the deployement to production in the [networking folder](https://github.com/rdansou/terraform-aws-multi-account/tree/master/environments/networking)
- and finally run from within the networking folder `terraform init`, `terraform plan`, and `terraform apply` to deploy the network resources

## Makefile targets

| Target | Description |
|--------|-----------|
| setup_env | Sets up Terraform plugins cache dir and creates environment specific Terraform variables inside the resources folder |
| check_aws_profile | Checks if the AWS profile configuration has been set in *~/.aws/config*. |
| check_resource_dir | Checks if a folder for the resources being deployed exists |
| tf_remote_state | Creates an S3 bucket and a DynamoDB table for Terraform remote state and creates a *terraform.tf* file that contains Terraform remote state configuration for the environment |
| tf_init | Creates and/or select Terraform workspace after calling the setting up the environment using the targets above, then runs `terraform init` |
| tf_plan | Runs `terraform plan` after running `tf_init` |
| tf_apply | Runs `terraform apply` after running `tf_plan` |
| tf_destroy | Runs `terraform destroy` after running `tf_init` |


## Resources

- [x] [Networking](https://github.com/rdansou/terraform-aws-multi-account/tree/master/resources/networking)
- [ ] [Containers](https://github.com/rdansou/terraform-aws-multi-account/tree/master/resources/containers)
- [ ] [Compute](https://github.com/rdansou/terraform-aws-multi-account/tree/master/resources/compute)
- [ ] [Security](https://github.com/rdansou/terraform-aws-multi-account/tree/master/resources/security)
- [ ] [Storage](https://github.com/rdansou/terraform-aws-multi-account/tree/master/resources/storage)

## License

Apache 2 Licensed. See [LICENSE](https://github.com/rdansou/terraform-aws-multi-account/blob/master/LICENSE) for full details.

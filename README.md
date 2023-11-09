# !!! WORK IN PROGRESS !!!

# leantime-aws

This project will deploy [Leantime](https://leantime.io/) to AWS using Free Tier services. This means you can deploy and use this completely for free for 12 months on AWS.

## Pre-requisites

- An active AWS account with programmatic access
- SSM Parameter Store: rds password

## Beginner Terraform Information

I'm not going to get too detailed here, but it's important to understand a few Terraform concepts first.

Terraform is a stateful infrastructure-as-code tool, which means that whenever you want to add something to your Terraform code, Terraform first reads from a `tfstate` file so it knows what has _already been deployed_ so it doesn't try to deploy it again.

The `tfstate` file is a record of what Terraform has already deployed, which means that if you have applied 99 resources already and want to apply the hundredth resource, Terraform will read the `tfstate` file, recognize that it only needs to deploy **one** resource instead of 100 resources.

Since Terraform code is often being updated and applied by multiple people or is getting applied via CI/CD pipelines automatically at any time, it's important to do two things with the `tfstate` file:

1. **Store it remotely**, in a location all developers and automation can access, instead of on a local machine.
2. **Lock the file** during Terraform operations. This way, you won't have two different people or automations trying to change the state simultaneously.

A very common way to handle those two items is to do this:

1. Store the `tfstate` file in an AWS S3 bucket.
2. Use AWS DynamoDB to handle the `tfstate` file locking.

This project uses the [trussworks/bootstrap/aws](https://registry.terraform.io/modules/trussworks/bootstrap/aws/latest) module to create these dependencies.

## Manual Deployment

### Deploy Dependencies

1. `cd` into the `terraform/bootstrap` directory.
2. Edit `bootstrap.tf` to replace the `account_alias` as this is globally unique. You will need a truly unique account alias.
3. Execute `terraform init` followed by `terraform apply`.

### Deploy Leantime

1. Be in the `terraform` directory.
2. In `backend.tf`, replace the names of the `bucket` to match what you created in `bootstrap`. Since my account alias is `willquill-leantime`, my bucket name is `willquill-leantime-tf-state-us-east-2`.
3. Execute `terraform init` followed by `terraform apply`.

## FAQ

*Q: Why use a public subnet instead of a private subnet?*

A: The only way for private subnet EC2 instance to access the internet is through NAT, and a NAT gateway costs money.

## Credit

Shout to Robert's repo [here](https://github.com/rnwood13/cloud-media-requests/)!

## License

Distributed under the MIT License. See LICENSE for more information.

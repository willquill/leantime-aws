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

This is why you'll often see a `backend.tf` file that looks like this:

```terraform
terraform {
  backend "s3" {
    bucket         = "leantime-aws-state-backend"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform_state"
    encrypt        = true
  }
}
```

If you want to configure all of your AWS resources via Terraform, you may have already noticed a problem with everything I just said. Specifically, you may be wondering:

**If your Terraform backend uses an S3 bucket and DynamoDB table, how do you use Terraform to create the S3 bucket and DynamoDB table in the first place?!**

This is an excellent question! It's a bit of a chicken and egg problem, isn't it?

Fortunately, it's a problem you only have to solve once when you are first starting out with your project. There are various methods to resolve it - but I prefer the following method.

Do the following:

1. Rename `backend.tf` to `backend.tf.inactive`
2. Execute `terraform init` followed by `terraform apply` to create your resources.
3. Rename `backend.tf.inactive` back to `backend.tf` and repeat step 2.
4. You will see the following, where you should enter "yes" and hit return:

```sh
➜ terraform init

Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "s3" backend. No existing state was found in the newly
  configured "s3" backend. Do you want to copy this state to the new "s3"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value:
```

Now you can delete the local `terraform.tfstate` since it has been replaced by the S3 backend.

## Manual Deployment

## FAQ

*Q: Why use a public subnet instead of a private subnet?*

A: The only way for private subnet EC2 instance to access the internet is through NAT, and a NAT gateway costs money.

## Credit

Shout to Robert's repo [here](https://github.com/rnwood13/cloud-media-requests/)!

## License

Distributed under the MIT License. See LICENSE for more information.

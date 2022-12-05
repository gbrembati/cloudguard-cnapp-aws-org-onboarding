# CloudGuard CNAPP AWS Organization Terraform Onboarding
This Terraform project is intended to be used to onboard an entire AWS organization accounts in one-shot.     
What it does is configuring, via **Terraform**, an existing CloudGuard CSPM Portal and AWS master account.      
 
## How to start?
First, you need to have a CloudGuard account, if you don't, you can create an *Infinity Portal* by clicking the image below:      
[<img src="https://www.checkpoint.com/wp-content/themes/checkpoint-theme-v2/images/checkpoint-logo.png">](https://portal.checkpoint.com/create-account)

## Get API credentials in your CloudGuard CNAPP Portal
Then you will need to get the API credentials that you will be using with Terraform to onboard the accounts.

![Architectural Design](/zimages/create-cpsm-serviceaccount.jpg)

Remember to copy these two values, you will need to enter them in the *.tfvars* file later on.

## Prerequisite
You would need to give as a parameter the External ID that you can obtain in the onboarding wizard:
![AWS External ID](/zimages/aws-external-id.jpg)

## How to use it
The only thing that you need to do is changing the __*terraform.tfvars*__ file located in this directory.

```hcl
# Set in this file your deployment variables
aws-access-key  = "xxxxxxxxxxxxxx"
aws-secret-key  = "xxxxxxxxxxxxxx"

cspm-key-id     = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
cspm-key-secret = "xxxxxxxxxxxxxxxxxxxx"
cspm-aws-external-id = "xxxxxxxxxxxxxxxxxxxx"
```
If you want (or need) to further customize other project details, you can change defaults in the different __*name-variables.tf*__ files.   
Here you will also able to find the descriptions that explains what each variable is used for.
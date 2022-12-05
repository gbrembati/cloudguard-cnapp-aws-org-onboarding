// --- AWS Provider ---
variable "region" {
  type = string
  description = "AWS region"
  default = "eu-west-1"
}
variable "aws-access-key" {
  description = "AWS access key"
  type = string
}
variable "aws-secret-key" {
  type = string
  description = "AWS secret key"
}

// --- CloudGuard Provider ---
variable "cspm-key-id" {
  description = "Insert your API Key ID"
  type = string
}
variable "cspm-key-secret" {
  description = "Insert your API Key Secret"
  type = string
  sensitive = true
}
variable "cspm-aws-external-id" {
  description = "Insert your Cloudguard External ID"
  type = string
}
variable "cspm-aws-role-suffix" {
  description = "Insert your Cloudguard Role suffix"
  type = string
  default = ""
}

variable "chkp-account-region-list" {
  description = "List of CloudGuard Account ID and API Endpoint"
  default = {
    Europe = ["723885542676","https://api.eu1.dome9.com/v2/"],
    America = ["634729597623","https://api.dome9.com/v2/"]
  }
}
locals {
  allowed_region_name = ["Europe","America"]
  validate_region_name = index(local.allowed_region_name, var.chkp-account-region)
}
variable "chkp-account-region" {
  description = "Insert your Cloudguard AWS Account residency region"
  type = string
}
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
    America   = ["634729597623","https://api.dome9.com/v2/"],
    Europe    = ["723885542676","https://api.eu1.dome9.com/v2/"],
    Singapore = ["597850136722","https://api.ap1.dome9.com/v2/"],
    Australia = ["434316140879","https://api.ap2.dome9.com/v2/"],
    India     = ["578204784313","https://api.ap3.dome9.com/v2/"]
  }
}
locals {
  allowed_region_name = ["Europe","America","Singapore","Australia","India"]
  validate_region_name = index(local.allowed_region_name, var.chkp-account-region)
}
variable "chkp-account-region" {
  description = "Insert your Cloudguard Account residency location"
  type = string
}
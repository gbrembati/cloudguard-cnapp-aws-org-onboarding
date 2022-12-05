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
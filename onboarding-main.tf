data "aws_organizations_organization" "aws-organization" {}

resource "dome9_cloudaccount_aws" "onboard-aws-account" {
  for_each    = { for account in toset(data.aws_organizations_organization.aws-organization.accounts) : account.name => account } 

  name  = each.value.name 

  credentials  {
    arn    = "arn:aws:iam::${each.value.id}:role/CloudGuard-Connect-RO-role${var.cspm-aws-role-suffix}"
    secret = var.cspm-aws-external-id
    type   = "RoleBased"
  } 
  net_sec {
    regions {
      new_group_behavior = "ReadOnly"
      region             = "us_east_1"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "us_west_1"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "eu_west_1"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "ap_southeast_1"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "ap_northeast_1"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "us_west_2"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "sa_east_1"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "ap_southeast_2"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "eu_central_1"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "ap_northeast_2"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "ap_south_1"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "us_east_2"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "ca_central_1"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "eu_west_2"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "eu_west_3"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "eu_north_1"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "ap_east_1"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "me_south_1"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "af_south_1"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "eu_south_1"
    }
    regions {
      new_group_behavior = "ReadOnly"
      region             = "ap_northeast_3"
    }
  }
  depends_on = [aws_cloudformation_stack_set_instance.cft-deploy-organization, aws_cloudformation_stack.cloudguard-master-account]
}

data "http" "github-chkp-repository" {
  url = "https://raw.githubusercontent.com/dome9/unified-onboarding/Release/cft/generated/templates/role_based/permissions_readonly_cft.yml"
}

resource "aws_cloudformation_stack" "cloudguard-master-account" {
  name = "cloudguard-master-account-onboarding"
  capabilities  = ["CAPABILITY_NAMED_IAM","CAPABILITY_IAM"]
  template_body = data.http.github-chkp-repository.response_body

  parameters = {
    CloudGuardAwsAccountId  = lookup(var.chkp-account-region-list, var.chkp-account-region)[0]
    RoleExternalTrustSecret = var.cspm-aws-external-id
    UniqueSuffix            = var.cspm-aws-role-suffix
  }
  tags = {
    "vendor"      = "check-point"
    "application" = "cloudguard-cnapp"
  }
}
resource "aws_cloudformation_stack_set" "cloudguard-org-onboarding" {
  name = "cloudguard-org-onboarding"
  permission_model  = "SERVICE_MANAGED"
  capabilities      = ["CAPABILITY_NAMED_IAM","CAPABILITY_IAM"]

  auto_deployment { enabled = true }
  operation_preferences {
    region_order = [ var.region ]
    max_concurrent_percentage     = 100
    failure_tolerance_percentage  = 100
  }

  template_body = data.http.github-chkp-repository.response_body
  parameters = {
    CloudGuardAwsAccountId  = lookup(var.chkp-account-region-list, var.chkp-account-region)[0]
    RoleExternalTrustSecret = var.cspm-aws-external-id
    UniqueSuffix            = var.cspm-aws-role-suffix
  }

  tags = {
    "vendor"      = "check-point"
    "application" = "cloudguard-cnapp"
  }
}
resource "aws_cloudformation_stack_set_instance" "cft-deploy-organization" {
  stack_set_name = aws_cloudformation_stack_set.cloudguard-org-onboarding.name
  stack_set_instance_region = var.region

  deployment_targets {
    organizational_unit_ids = [data.aws_organizations_organization.aws-organization.roots[0].id]
  }
}
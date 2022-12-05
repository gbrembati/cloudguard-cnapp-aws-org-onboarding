data "aws_organizations_organization" "aws-organization" {}

# Create a dedicated Org-unit under the root one
resource "dome9_organizational_unit" "my-org-unit" {
  name      = "AWS Environments"
  parent_id = "00000000-0000-0000-0000-000000000000"
}

resource "dome9_cloudaccount_aws" "onboard-aws-account" {
  count = length(data.aws_organizations_organization.aws-organization.accounts)

  name  = data.aws_organizations_organization.aws-organization.accounts[count.index].name
  credentials  {
    arn    = "arn:aws:iam::${data.aws_organizations_organization.aws-organization.accounts[count.index].id}:role/CloudGuard-Connect-RO-role${var.cspm-aws-role-suffix}"
    secret = var.cspm-aws-external-id
    type   = "RoleBased"
  } 
  organizational_unit_id = dome9_organizational_unit.my-org-unit.id
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
  capabilities      = ["CAPABILITY_NAMED_IAM","CAPABILITY_IAM"]

  template_body = data.http.github-chkp-repository.response_body
  parameters = {
    CloudGuardAwsAccountId  = lookup(var.chkp-account-region-list, var.chkp-account-region)[0]
    RoleExternalTrustSecret = var.cspm-aws-external-id
    UniqueSuffix            = var.cspm-aws-role-suffix
  }
}
resource "aws_cloudformation_stack_set" "cloudguard-org-onboarding" {
  name = "cloudguard-org-onboarding"
  permission_model  = "SERVICE_MANAGED"
  capabilities      = ["CAPABILITY_NAMED_IAM","CAPABILITY_IAM"]

  auto_deployment { enabled = true }
  operation_preferences {
    region_order = ["eu-west-1"]
    max_concurrent_count = 100
  }

  template_body = data.http.github-chkp-repository.response_body
  parameters = {
    CloudGuardAwsAccountId  = lookup(var.chkp-account-region-list, var.chkp-account-region)[0]
    RoleExternalTrustSecret = var.cspm-aws-external-id
    UniqueSuffix            = var.cspm-aws-role-suffix
  }
}
resource "aws_cloudformation_stack_set_instance" "cft-deploy-organization" {
  region         = var.region
  stack_set_name = aws_cloudformation_stack_set.cloudguard-org-onboarding.name

  deployment_targets {
    organizational_unit_ids = [data.aws_organizations_organization.aws-organization.roots[0].id]
  }
}
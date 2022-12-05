terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.44.0"
    }
    dome9 = {
      source = "dome9/dome9"
      version = "~> 1.28.5"
    }    
  }
}

provider "aws" {
  region     = var.region
  access_key = var.aws-access-key
  secret_key = var.aws-secret-key
}

provider "dome9" {
  dome9_access_id   = var.cspm-key-id
  dome9_secret_key  = var.cspm-key-secret
  base_url = "https://api.eu1.dome9.com/v2/"  // EU - api.eu1.dome9.com/v2 | US - api.dome9.com/v2
}

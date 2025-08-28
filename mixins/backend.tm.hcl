generate_hcl "_bucket.tf" {
  condition = tm_try(global.terraform.create_s3_backend, false) && !tm_contains(terramate.stack.tags, "no-terraform")
  content {
    variable "bucket" {
      description = "Bucket name"
      type        = string
    }

    module "terraform_backend" {
      source  = "gitlab.eu.idnow.group/infrastructure/idnow-s3-backend/aws"
      version = "0.0.4"

      bucket_name = var.bucket
    }
  }
}

generate_hcl "_tags.tf" {
  condition = !tm_contains(terramate.stack.tags, "no-terraform")
  content {
    locals {
      tm_dynamic "tags =" {
        attributes = tm_try(global.tags, {})
      }
    }
  }
}


generate_hcl "_backend.tf" {
  condition = !tm_contains(terramate.stack.tags, "no-backend") && !tm_contains(terramate.stack.tags, "no-terraform")

  content {
    # Backend configuration
    terraform {
      backend "s3" {
        key            = tm_try(global.terraform.backend.key, "terraform/stacks/by-id/${terramate.stack.id}/terraform.tfstate")
        encrypt        = true
        dynamodb_table = tm_try(global.terraform.backend.dynamodb_table, "terraform-state-lock")
      }
    }
    
    variable "bucket" {
      description = "Terraform state bucket name"
      type        = string
    }
    
    variable "kms_key_id" {
      description = "KMS Key ID for the terraform state bucket"
      type        = string
    }
  }
}

generate_hcl "_backend.tf" {
  condition = tm_contains(terramate.stack.tags, "no-backend") && !tm_contains(terramate.stack.tags, "no-terraform")

  content {
    # Backend configuration
    terraform {
      backend "local" { }
    }
  }
}

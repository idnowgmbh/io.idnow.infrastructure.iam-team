generate_hcl "_provider.tf" {
  condition = !tm_contains(terramate.stack.tags, "no-terraform")
  content {
    variable "region" {
      description = "Region name"
      type        = string
    }

    variable "profile" {
      description = "Profile name"
      type        = string
    }

    variable "tags" {
      description = "Default tags"
      type        = map
    }

    variable "env" {
      description = "Environment"
      type        = string
    }

    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 5.59"
        }
        controltower = {
          source  = "idealo/controltower"
          version = "~> 2.2"
        }
        awsutils = {
          source = "cloudposse/awsutils"
        }
        gitlab = {
          source  = "gitlabhq/gitlab"
          version = "~> 18.1"
        }
      }
    }

    provider "aws" {
      region  = var.region
      profile = var.profile
      
      default_tags {
        tags = merge(local.tags, var.tags)
      }
    }

    provider "awsutils" {
      region  = var.region
      profile = var.profile
    }

    provider "controltower" {
      region  = var.region
      profile = var.profile
    }
  }
}

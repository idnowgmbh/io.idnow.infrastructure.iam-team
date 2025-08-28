# TEAM Amplify Application Infrastructure
# Converted from deployment/template.yml
# Configured for manual deployment (no repository connection)

# IAM Role for Amplify
resource "aws_iam_role" "amplify_role" {
  name = "AmplifyRole-${var.env}"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "amplify.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]

  tags = var.tags
}

# Amplify Application (Manual Deployment - No Repository)
resource "aws_amplify_app" "team_app" {
  name        = "TEAM-IDC-APP"
  description = "Temporary Elevated Access Management Application"

  # No repository configuration for manual deployment
  iam_service_role_arn = aws_iam_role.amplify_role.arn

  # Custom rules for SPA routing
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }

  # Environment variables
  environment_variables = {
    AMPLIFY_DESTRUCTIVE_UPDATES = "true"
    _LIVE_UPDATES = "[{\"name\":\"Node.js version\",\"pkg\":\"node\",\"type\":\"nvm\",\"version\":\"22.17\"}]"
  }

  build_spec = <<-EOT
    version: 1
    backend:
      phases:
        preBuild:
          commands:
            - '# 14.0.0 Enforces SSL on S3 deployment bucket'
            - npm i -g @aws-amplify/cli@14.0.0
            - '# Update deployment parameters with helper script'
            - node parameters.js
        build:
          commands:
            - npm i -S graphql-ttl-transformer
            - '# Execute Amplify CLI with the helper script'
            - pip3 install --user pipenv==2023.6.12
            - export PATH=$HOME/.local/bin:$PATH
            - amplifyPush --simple --allow-destructive-graphql-schema-update
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  tags = merge(var.tags, {
    Name = "TEAM"
  })
}

# Amplify Branch
resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.team_app.id
  branch_name = "main"

  enable_auto_build = true

  environment_variables = {
    SSO_LOGIN           = var.sso_login_url
    TEAM_ACCOUNT        = var.team_account_id
    CLOUDTRAIL_AUDIT_LOGS = var.cloudtrail_audit_logs != "" ? var.cloudtrail_audit_logs : "read_write"
    TEAM_ADMIN_GROUP    = var.team_admin_group
    TEAM_AUDITOR_GROUP  = var.team_audit_group
    TAGS                = var.tags_json
    AMPLIFY_CUSTOM_DOMAIN = var.custom_amplify_domain
    _CUSTOM_IMAGE       = "amplify:al2023"
  }

  tags = {
    Branch = "main"
  }
}

# IAM Role for Lambda function that triggers Amplify build
resource "aws_iam_role" "amplify_lambda_role" {
  name = "AmplifyLambdaRole-${var.env}"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "AmplifyLambdaPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "AllowLogging"
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "*"
        },
        {
          Sid    = "startBuild"
          Effect = "Allow"
          Action = [
            "amplify:StartJob"
          ]
          Resource = "*"
        }
      ]
    })
  }

  tags = var.tags
}

# Lambda function to trigger Amplify build
resource "aws_lambda_function" "trigger_build" {
  filename         = data.archive_file.trigger_build_zip.output_path
  function_name    = "TriggerAmplifyBuild-${var.env}"
  role            = aws_iam_role.amplify_lambda_role.arn
  handler         = "index.handler"
  runtime         = "python3.10"
  timeout         = 120
  architectures   = ["arm64"]

  source_code_hash = data.archive_file.trigger_build_zip.output_base64sha256

  tags = var.tags
}

# Create zip file for Lambda function
data "archive_file" "trigger_build_zip" {
  type        = "zip"
  output_path = "${path.module}/trigger_build.zip"
  
  source {
    content = <<EOF
import json
import cfnresponse
import boto3
import logging
from botocore.exceptions import ClientError

client = boto3.client('amplify')
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    logger.info("Received event: %s" % json.dumps(event))
    appId = event['ResourceProperties']['appId']
    branchName = event['ResourceProperties']['branchName']

    result = cfnresponse.SUCCESS
    try:
        if event['RequestType'] == 'Create' or event['RequestType'] == 'Update':
            response = client.start_job(
                appId = appId,
                branchName = branchName,
                jobType='RELEASE'
            )
        elif event['RequestType'] == 'Delete':
            pass
    except ClientError as e:
        logger.error('Error: %s', e)
        result = cfnresponse.FAILED
    cfnresponse.send(event, context, result, {})
EOF
    filename = "index.py"
  }
}

# Custom resource to trigger Amplify build
resource "aws_cloudformation_stack" "trigger_amplify_build" {
  name = "trigger-amplify-build-${var.env}"

  template_body = jsonencode({
    AWSTemplateFormatVersion = "2010-09-09"
    Resources = {
      TriggerAmplifyBuild = {
        Type = "Custom::TriggerAmplifyBuild"
        Properties = {
          ServiceToken = aws_lambda_function.trigger_build.arn
          appId        = aws_amplify_app.team_app.id
          branchName   = "main"
          branch       = aws_amplify_branch.main.arn
        }
      }
    }
  })

  tags = var.tags

  depends_on = [
    aws_amplify_app.team_app,
    aws_amplify_branch.main,
    aws_lambda_function.trigger_build
  ]
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

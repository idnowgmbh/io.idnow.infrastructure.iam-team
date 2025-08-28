# TEAM Application Deployment Guide

This guide explains how to deploy the TEAM (Temporary Elevated Access Management) application using the new Terramate + OpenTofu infrastructure with GitLab CI/CD for frontend deployment.

## Overview

The deployment uses a hybrid approach:
- **Infrastructure**: Managed by Terramate + OpenTofu (AWS Amplify app, IAM roles, etc.)
- **Frontend**: Deployed via GitLab CI/CD pipeline to the Amplify app
- **Backend**: Remains in Amplify backend (CloudFormation templates preserved)

## Prerequisites

1. **AWS Credentials**: Access to sandbox (147997160594) and production (718226530287) accounts
2. **Terramate**: Installed and configured
3. **OpenTofu**: Installed and configured
4. **GitLab CI/CD**: Access to configure variables in your GitLab project

## Infrastructure Deployment

### 1. Deploy to Sandbox Environment

```bash
cd stacks/iam-team
ENVIRONMENT=sbx terramate run -- tofu apply
```

### 2. Deploy to Production Environment

```bash
cd stacks/iam-team
ENVIRONMENT=prd terramate run -- tofu apply
```

### 3. Get Amplify App IDs

After deployment, note the Amplify App IDs from the outputs:

```bash
# Sandbox
ENVIRONMENT=sbx terramate run -- tofu output amplify_app_id

# Production
ENVIRONMENT=prd terramate run -- tofu output amplify_app_id
```

## GitLab CI/CD Setup

### 1. Configure GitLab CI/CD Variables

In your GitLab project, go to **Settings > CI/CD > Variables** and add:

#### Sandbox Environment
- `AWS_ACCESS_KEY_ID_SBX`: AWS access key for sandbox account
- `AWS_SECRET_ACCESS_KEY_SBX`: AWS secret key for sandbox account
- `AMPLIFY_APP_ID_SBX`: Amplify app ID from Terraform output (sandbox)

#### Production Environment
- `AWS_ACCESS_KEY_ID_PRD`: AWS access key for production account
- `AWS_SECRET_ACCESS_KEY_PRD`: AWS secret key for production account
- `AMPLIFY_APP_ID_PRD`: Amplify app ID from Terraform output (production)

### 2. Enable the Pipeline

Replace your current `.gitlab-ci.yml` with the provided `.gitlab-ci-amplify.yml`:

```bash
mv .gitlab-ci-amplify.yml .gitlab-ci.yml
```

Or merge the deployment stages into your existing pipeline.

### 3. Pipeline Behavior

- **Automatic Deployment**: Pushes to `main` branch automatically deploy to sandbox
- **Manual Deployment**: Production deployment requires manual approval
- **Build Artifacts**: React build artifacts are cached between stages

## Deployment Process

### Automatic (Sandbox)

1. Push code to `main` branch
2. GitLab CI/CD builds the React application
3. Automatically deploys to sandbox Amplify app
4. Access via: `https://{AMPLIFY_APP_ID_SBX}.amplifyapp.com`

### Manual (Production)

1. After sandbox deployment succeeds
2. Go to GitLab CI/CD pipeline
3. Click "Deploy Production" manual action
4. Deploys to production Amplify app
5. Access via: `https://{AMPLIFY_APP_ID_PRD}.amplifyapp.com`

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   GitLab Repo   │───▶│  GitLab CI/CD    │───▶│  AWS Amplify    │
│                 │    │                  │    │                 │
│ - Source Code   │    │ - Build React    │    │ - Host Frontend │
│ - CI/CD Config  │    │ - Deploy to AWS  │    │ - CDN + SSL     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                         │
                                                         ▼
                                               ┌─────────────────┐
                                               │ Amplify Backend │
                                               │                 │
                                               │ - GraphQL API   │
                                               │ - DynamoDB      │
                                               │ - Lambda        │
                                               │ - Step Functions│
                                               └─────────────────┘
```

## Infrastructure Components

### Created by Terraform
- AWS Amplify App (without repository connection)
- AWS Amplify Branch (main)
- IAM Roles for Amplify and Lambda
- Lambda function for build triggers
- CloudFormation stack for custom resources

### Preserved in Amplify Backend
- GraphQL API (AppSync)
- DynamoDB tables
- Lambda functions (business logic)
- Step Functions workflows
- Authentication (Cognito)
- CloudTrail Lake integration

## Troubleshooting

### Common Issues

1. **Pipeline Fails with "AMPLIFY_APP_ID not set"**
   - Ensure GitLab CI/CD variables are configured correctly
   - Check that Terraform deployment completed successfully

2. **AWS Credentials Error**
   - Verify AWS credentials have proper permissions
   - Check that credentials are for the correct AWS account

3. **Build Fails**
   - Check Node.js version compatibility
   - Verify package.json and dependencies

4. **Deployment Upload Fails**
   - Check AWS Amplify service permissions
   - Verify the Amplify app exists and is accessible

### Useful Commands

```bash
# Check Terraform state
ENVIRONMENT=sbx terramate run -- tofu state list

# Get Amplify app details
aws amplify get-app --app-id {AMPLIFY_APP_ID}

# List Amplify deployments
aws amplify list-jobs --app-id {AMPLIFY_APP_ID} --branch-name main

# Manual deployment (if needed)
aws amplify create-deployment --app-id {AMPLIFY_APP_ID} --branch-name main
```

## Security Considerations

- AWS credentials are stored as GitLab CI/CD variables (masked)
- Amplify app uses IAM roles with least privilege
- Production deployments require manual approval
- All resources are tagged for cost tracking and compliance

## Next Steps

1. Deploy infrastructure to both environments
2. Configure GitLab CI/CD variables
3. Test deployment pipeline with a small change
4. Set up monitoring and alerting for the application
5. Configure custom domain (if needed)

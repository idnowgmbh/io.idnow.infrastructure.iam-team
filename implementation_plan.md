# AWS TEAM Implementation Plan - Terramate + OpenTofu Deployment

## [Overview]

Deploy AWS TEAM (Temporary Elevated Access Management) solution to identity account infrastructure using Terramate + OpenTofu for backend infrastructure while maintaining Amplify for frontend hosting.

**Detailed Scope and Approach:**
This implementation converts the existing CloudFormation-based AWS TEAM solution to a Terramate + OpenTofu infrastructure-as-code approach. The solution provides time-bound elevated access management for AWS accounts through IAM Identity Center integration. The hybrid deployment strategy maintains Amplify for frontend hosting while migrating all backend infrastructure (DynamoDB, Lambda, Step Functions, AppSync, IAM roles) to OpenTofu modules managed by Terramate. The implementation supports both sandbox (sbx) and production (prd) environments with separate AWS accounts and state management.

## [Types]

**Core Data Structures:**
- `Request`: Access request entity with approval workflow state
- `Approver`: User authorization and approval delegation configuration  
- `Eligibility`: Account/permission set access eligibility rules
- `Session`: Active elevated access session tracking
- `Settings`: Global application configuration and policies
- `AuditLog`: CloudTrail Lake integration for compliance tracking

**Environment Configuration Types:**
- `EnvironmentConfig`: Environment-specific variables (account IDs, regions, etc.)
- `BackendConfig`: Terramate backend configuration for state management
- `ProviderConfig`: AWS provider configuration with assume role setup
- `TagConfig`: Standardized resource tagging across environments

## [Files]

**New Files to Create:**
- `stacks/iam-team/modules/dynamodb/main.tf` - DynamoDB tables configuration
- `stacks/iam-team/modules/dynamodb/variables.tf` - DynamoDB module variables
- `stacks/iam-team/modules/dynamodb/outputs.tf` - DynamoDB table ARNs and names
- `stacks/iam-team/modules/lambda/main.tf` - Lambda functions and layers
- `stacks/iam-team/modules/lambda/variables.tf` - Lambda module variables  
- `stacks/iam-team/modules/lambda/outputs.tf` - Lambda function ARNs
- `stacks/iam-team/modules/stepfunctions/main.tf` - Step Functions workflows
- `stacks/iam-team/modules/stepfunctions/variables.tf` - Step Functions variables
- `stacks/iam-team/modules/stepfunctions/outputs.tf` - Step Functions ARNs
- `stacks/iam-team/modules/appsync/main.tf` - AppSync GraphQL API configuration
- `stacks/iam-team/modules/appsync/variables.tf` - AppSync module variables
- `stacks/iam-team/modules/appsync/outputs.tf` - AppSync API details
- `stacks/iam-team/modules/iam/main.tf` - IAM roles and policies
- `stacks/iam-team/modules/iam/variables.tf` - IAM module variables
- `stacks/iam-team/modules/iam/outputs.tf` - IAM role ARNs
- `stacks/iam-team/modules/cloudtrail/main.tf` - CloudTrail Lake integration
- `stacks/iam-team/modules/cloudtrail/variables.tf` - CloudTrail variables
- `stacks/iam-team/modules/cloudtrail/outputs.tf` - CloudTrail resources
- `stacks/iam-team/lambda-src/` - Lambda function source code directory
- `stacks/iam-team/lambda-src/router/` - Router Lambda source
- `stacks/iam-team/lambda-src/resolvers/` - GraphQL resolver Lambda sources

**Files to Modify:**
- `stacks/iam-team/main.tf` - Replace MCP config with TEAM module calls
- `stacks/iam-team/variables.tf` - Add TEAM-specific variables
- `stacks/iam-team/outputs.tf` - Add TEAM infrastructure outputs
- `stacks/iam-team/envs/sbx.tm.hcl` - Add sandbox environment variables
- `stacks/iam-team/envs/prd.tm.hcl` - Add production environment variables
- `amplify/backend/backend-config.json` - Update for TEAM configuration
- `amplify/backend/api/team/schema.graphql` - Ensure GraphQL schema alignment

**Files to Delete:**
- Current MCP-related configurations in `stacks/iam-team/main.tf`

**Configuration Updates:**
- Update Terramate mixins to support TEAM-specific resource tagging
- Configure environment-specific backend state buckets for TEAM resources
- Update GitLab CI/CD pipeline for TEAM deployment workflows

## [Functions]

**New Lambda Functions:**
- `teamRouter`: Main GraphQL resolver router function
  - Purpose: Route GraphQL operations to appropriate business logic
  - Inputs: AppSync GraphQL events
  - Outputs: GraphQL responses
  - Dependencies: DynamoDB tables, IAM permissions

- `teamGetAccounts`: Retrieve available AWS accounts
  - Purpose: Fetch accounts from IAM Identity Center
  - Inputs: User context, filters
  - Outputs: Account list with metadata
  - Dependencies: IAM Identity Center API access

- `teamGetPermissionSets`: Retrieve permission sets
  - Purpose: Fetch available permission sets for accounts
  - Inputs: Account ID, user context
  - Outputs: Permission set list
  - Dependencies: IAM Identity Center API access

- `teamGetUsers`: User management operations
  - Purpose: Retrieve and manage user information
  - Inputs: User queries, filters
  - Outputs: User data and permissions
  - Dependencies: IAM Identity Center, Cognito

**Modified Functions:**
- Update existing Amplify Lambda functions to integrate with new infrastructure
- Migrate CloudFormation-based Lambda configurations to OpenTofu

**Removed Functions:**
- MCP server-related Lambda functions (if any exist)

## [Classes]

**New OpenTofu Module Classes:**
- `DynamoDBModule`: Manages all TEAM DynamoDB tables
  - Properties: table configurations, indexes, encryption
  - Methods: table creation, backup configuration, scaling policies

- `LambdaModule`: Manages Lambda functions and layers
  - Properties: function configurations, environment variables, VPC settings
  - Methods: function deployment, layer management, permission setup

- `StepFunctionsModule`: Manages workflow orchestration
  - Properties: state machine definitions, IAM roles, logging
  - Methods: workflow creation, execution role setup, CloudWatch integration

- `AppSyncModule`: Manages GraphQL API infrastructure
  - Properties: API configuration, data sources, resolvers
  - Methods: API creation, schema deployment, authentication setup

- `IAMModule`: Manages roles and policies
  - Properties: role definitions, policy documents, trust relationships
  - Methods: role creation, policy attachment, cross-account access

**Modified Classes:**
- Update existing Terramate configuration classes for TEAM-specific requirements
- Enhance environment configuration classes with TEAM variables

**Removed Classes:**
- MCP server configuration classes

## [Dependencies]

**New Package Dependencies:**
- OpenTofu AWS provider (>= 5.0)
- Terramate CLI (latest stable)
- AWS CLI v2 for deployment operations

**Infrastructure Dependencies:**
- AWS IAM Identity Center (prerequisite)
- AWS Cognito User Pool (managed by Amplify)
- AWS AppSync (managed by OpenTofu)
- DynamoDB (managed by OpenTofu)
- Lambda runtime environments (Python 3.9+, Node.js 18+)
- Step Functions service
- CloudTrail Lake service

**Integration Requirements:**
- Amplify CLI for frontend deployment
- GitLab CI/CD integration for automated deployments
- AWS credentials and permissions for cross-account access
- Terramate backend state storage (S3 + DynamoDB)

**Version Constraints:**
- Terraform/OpenTofu >= 1.5.0
- AWS Provider >= 5.0.0
- Terramate >= 0.4.0

## [Testing]

**Unit Testing Approach:**
- OpenTofu module validation using `tofu validate`
- Terramate configuration testing with `terramate validate`
- Lambda function unit tests using pytest (Python) and Jest (Node.js)
- GraphQL schema validation against AppSync requirements

**Integration Testing Strategy:**
- Deploy to sandbox environment for end-to-end testing
- Test GraphQL API endpoints with sample requests
- Validate Step Functions workflow execution
- Test IAM role assumption and permission boundaries
- Verify DynamoDB table operations and data consistency

**Validation Strategies:**
- Infrastructure drift detection using Terramate
- Security policy validation using AWS Config rules
- Performance testing of Lambda functions under load
- CloudTrail log validation for audit compliance
- Cross-account access testing for IAM Identity Center integration

**Test Environment Setup:**
- Sandbox environment for safe testing
- Automated testing pipeline in GitLab CI/CD
- Test data seeding for DynamoDB tables
- Mock IAM Identity Center responses for unit tests

## [Implementation Order]

1. **Environment Preparation**
   - Validate existing Terramate configuration
   - Ensure AWS credentials and permissions are configured
   - Verify backend state buckets exist for both environments

2. **Core Infrastructure Modules**
   - Create DynamoDB module with all required tables
   - Implement IAM module with roles and policies
   - Set up CloudTrail Lake integration module

3. **Compute Layer**
   - Develop Lambda module with function configurations
   - Create Lambda layer for shared dependencies
   - Implement Step Functions workflows module

4. **API Layer**
   - Configure AppSync GraphQL API module
   - Set up data sources and resolvers
   - Integrate with Lambda functions

5. **Lambda Function Implementation**
   - Migrate existing Lambda source code to new structure
   - Update function configurations for new infrastructure
   - Test individual function deployments

6. **Integration Configuration**
   - Update main.tf to orchestrate all modules
   - Configure environment-specific variables
   - Set up cross-module dependencies

7. **Amplify Frontend Integration**
   - Update Amplify backend configuration
   - Ensure GraphQL schema compatibility
   - Configure authentication integration

8. **Environment Deployment**
   - Deploy to sandbox environment first
   - Validate all components work together
   - Run integration tests

9. **Production Preparation**
   - Review security configurations
   - Validate backup and disaster recovery
   - Prepare production deployment

10. **Production Deployment**
    - Deploy to production environment
    - Monitor deployment health
    - Validate production functionality

11. **Documentation and Handover**
    - Update deployment documentation
    - Create operational runbooks
    - Provide team training materials

12. **Post-Deployment Validation**
    - Conduct security review
    - Performance baseline establishment
    - Monitoring and alerting setup

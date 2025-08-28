terramate {
  config {
    git {
      default_remote = "origin"
      default_branch = "master"

      check_untracked   = false
      check_uncommitted = false
      check_remote      = false
    }

    run {
      env {
        TF_CLI_ARGS_apply="-var='env=${env.ENVIRONMENT}' -var-file=envs/${env.ENVIRONMENT}/_variables.tfvars -var-file=envs/${env.ENVIRONMENT}/_backend.tfvars -compact-warnings"
        TF_CLI_ARGS_plan="-var='env=${env.ENVIRONMENT}' -var-file=envs/${env.ENVIRONMENT}/_variables.tfvars -var-file=envs/${env.ENVIRONMENT}/_backend.tfvars -compact-warnings"
        TF_CLI_ARGS_destroy="-var='env=${env.ENVIRONMENT}' -var-file=envs/${env.ENVIRONMENT}/_variables.tfvars -var-file=envs/${env.ENVIRONMENT}/_backend.tfvars -compact-warnings"
        TF_CLI_ARGS_import="-var='env=${env.ENVIRONMENT}' -var-file=envs/${env.ENVIRONMENT}/_variables.tfvars -var-file=envs/${env.ENVIRONMENT}/_backend.tfvars -compact-warnings"
        TF_CLI_ARGS_init="-backend-config=envs/${env.ENVIRONMENT}/_backend.tfvars -compact-warnings"
      }
    }
  }
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  environment = local.environment_vars.locals.environment
  tags = local.environment_vars.locals.tags
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../modules/expense-manager"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  environment = local.environment  
  tags = local.tags

  app_name = "expense-manager"

  ui_code_pipeline_name = "expense-manager-ui-app-pipeline"
  ui_code_build_project = "expense-manager-ui-app-build"

  ui_app_bucket_name = "expense-manager-ui-app"
  
  github_connection = "vignesh-github"
  ui_code_pipeline_artefact_bucket = "expense-manager-ui-pipeline-artefact"


  mgmt_code_pipeline_name = "expense-manager-management-pipeline"
  mgmt_code_build_project = "expense-manager-management-build"

  mgmt_code_pipeline_artefact_bucket = "expense-manager-mgmt-pipeline-artefact"

  mgmt_lambda_bucket_name = "expense-manager-management"
  mgmt_lambda_zip = "expense-manager-lambdas.zip"
}


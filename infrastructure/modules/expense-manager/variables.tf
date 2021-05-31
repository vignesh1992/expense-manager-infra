variable "ui_code_build_project" {
  description = "UI App code build project name"
  type        = string
}

variable "ui_code_pipeline_name" {
  description = "UI App code pipeline name"
  type        = string
}

variable "ui_code_pipeline_artefact_bucket" {
  description = "UI App code pipeline artefact bucket"
  type        = string
}

variable "github_connection" {
  description = "UI Pipeline Github connection name"
  type        = string
}

variable "ui_app_bucket_name" {
  description = "UI app bucket name"
  type        = string
}

variable "tags" {
  description = "Tags for all the AWS components"
  type        = map(any)
}

variable "mgmt_lambda_bucket_name" {
  description = "Bucket to hold lambda function zip"
  type        = string
}

variable "mgmt_lambda_zip" {
  description = "Name of lambda function zip"
  type        = string
}

variable "app_name" {
  description = "Application Name"
  type        = string
}

variable "mgmt_code_pipeline_name" {
  description = "Management Code pipeline name"
  type        = string
}

variable "mgmt_code_build_project" {
  description = "Management code pipeline project name"
  type        = string
}

variable "mgmt_code_pipeline_artefact_bucket" {
  description = "Bucket to hold artefacts of pipeline"
  type        = string
}
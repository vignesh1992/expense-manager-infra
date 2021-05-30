variable "ui_code_build_project" {
  description = "UI App code build project name"
  type        = string
}

variable "ui_code_pipeline_name" {
  description = "UI App code pipeline name"
  type        = string
}

variable "ui_code_pipeline_bucket" {
  description = "UI App code pipeline artefact bucket"
  type        = string
}

variable "ui_app_bucket" {
  description = "UI App static site bucket"
  type        = string
}

variable "ui_github_connection" {
  description = "UI Pipeline Github connection name"
  type        = string
}
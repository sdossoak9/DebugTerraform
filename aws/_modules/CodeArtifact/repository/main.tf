resource "aws_codeartifact_repository" "artifact_repository" {
  repository = var.repository_name
  domain_owner = var.domain_owner
  domain     = var.domain_name
  description = var.description

}
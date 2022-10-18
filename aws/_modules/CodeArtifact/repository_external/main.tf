resource "aws_codeartifact_repository" "artifact_repository_with_external" {
  repository = var.repository_name
  domain_owner = var.domain_owner
  domain     = var.domain_name
  description = var.description

  external_connections {
    external_connection_name = var.external_connection_name
  }
}
resource "aws_codeartifact_repository" "artifact_repository_with_upstream" {
  repository = var.repository_name
  domain_owner = var.domain_owner
  domain     = var.domain_name
  description = var.description

  upstream {
    repository_name = var.upstream_sac_repo_name
  }

  upstream {
    repository_name = var.upstream_pypi_repo_name
  }

  upstream {
    repository_name = var.upstream_blueprints_repo_name
  }

}
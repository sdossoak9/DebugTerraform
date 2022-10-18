variable "kms" {
  type    = string
  default = "KMS"
}

variable "brs_ecr_repo_name" {
  type    = string
  default = "oak9sac-brs"
}

variable "grpc_ecr_repo_name" {
  type    = string
  default = "oak9sac-grpc"
}

variable "console_api_ecr_repo_name" {
  type    = string
  default = "oak9-console-api"
}

variable "argocd_repo_name" {
  type    = string
  default = "argocd"
}

variable "functionbeat_repo_name" {
  type    = string
  default = "functionbeat"
}

variable "grpc_dotnet_repo_name" {
  type    = string
  default = "grpc-dotnet-node"
}

variable "grpc_python_repo_name" {
  type    = string
  default = "grpc-python-node"
}

variable "jenkins_docker_repo_name" {
  type    = string
  default = "jenkins-docker"
}

variable "jenkins_dotnet_repo_name" {
  type    = string
  default = "jenkins-dotnet"
}

variable "jenkins_go_repo_name" {
  type    = string
  default = "jenkins-go"
}

variable "jenkins_grpc_repo_name" {
  type    = string
  default = "jenkins-grpc-dotnet"
}

variable "jenkins_grpc_python_repo_name" {
  type    = string
  default = "jenkins-grpc-python"
}

variable "jenkins_lambda_repo_name" {
  type    = string
  default = "jenkins-lambda"
}

variable "jenkins_node_repo_name" {
  type    = string
  default = "jenkins-node"
}

variable "jenkins_terraform_repo_name" {
  type    = string
  default = "jenkins-terraform"
}

variable "k8sops_repo_name" {
  type    = string
  default = "k8sops"
}

variable "sac_blueprints_repo_name" {
  type    = string
  default = "oak9-sac-blueprints"
}

variable "dev_ecr_repo_name" {
  type    = string
  default = "oak9-dev-ecr"
}

variable "oak9_jenkins_repo_name" {
  type    = string
  default = "oak9-jenkins"
}

variable "oak9_sac_async_repo_name" {
  type    = string
  default = "oak9sac-async"
}

variable "oak9_sac_queue_repo_name" {
  type    = string
  default = "oak9sac-queue"
}

variable "tfops_repo_name" {
  type    = string
  default = "tfops"
}

variable "pytest_repo_name" {
  type    = string
  default = "pytest"
}

variable "dotnet6_upgrade" {
  type    = string
  default = "jenkins-dotnet6-upgrade"
}
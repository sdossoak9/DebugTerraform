resource "aws_codeartifact_repository_permissions_policy" "oak9io" {
  repository      = aws_codeartifact_repository.artifact_repository_with_external.repository
  domain          = var.domain_name
  policy_document = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ContributorPolicy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "codeartifact:*",
                "sts:GetServiceBearerToken"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "o-ca3btxlrpf"
                }
            }
        }
    ]
}
EOF
}
resource "aws_codeartifact_domain_permissions_policy" "oak9io" {
  domain          = aws_codeartifact_domain.artifact_domain.domain
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
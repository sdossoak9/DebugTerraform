resource "aws_iam_role" "s3replication" {
  name        = "s3replication"
  description = "Allow S3 to assume the role for replication"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "s3ReplicationAssume",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "s3replication" {
  role      = aws_iam_role.s3replication.name
  policy_arn = aws_iam_policy.s3replication.arn
}

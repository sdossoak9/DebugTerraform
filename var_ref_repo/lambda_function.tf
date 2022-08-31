 # IAM role for the Lambda function.
resource "aws_iam_role" "lambda_exec_role" {
   name = var.iamRoleName
   count = 2
   depends_on = [
     abc.123,
     cool.dependency
   ]
   assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_lambda_function" "Oak9SampleFunction" {
   function_name = var.lambdaFunctionName

   # A S3 bucket, where we could deploy the builds
   s3_bucket = var.s3Bucket
   s3_key    = var.s3Key

   # Handler file along with the exported function 'handler'
   handler = var.handler

   # Runtime of Lambda function 
   runtime = var.runtime

   role = aws_iam_role.lambda_exec_role.arn
}


resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.Oak9SampleFunction.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" grants access from any method on any resource
   # This could be changed later on
   source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}


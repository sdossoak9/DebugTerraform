resource "aws_dynamodb_table" "basic-table-9" {
  name           = var.basic-table-9_aws_dynamodb_table
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  range_key      = "status"

  point_in_time_recovery {
    enabled = var.enable_POITB
  }

  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "status"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table-9"
    Environment = var.environment
  }
}

resource "aws_appautoscaling_target" "read_target_table9" {
  count              = aws_dynamodb_table.basic-table-9.billing_mode == "PROVISIONED" ? 1 : 0
  max_capacity       = 4000
  min_capacity       = 25
  resource_id        = "table/${aws_dynamodb_table.basic-table-9.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [aws_dynamodb_table.basic-table-9]
}

resource "aws_appautoscaling_policy" "read_policy_table9" {
  count              = aws_dynamodb_table.basic-table-9.billing_mode == "PROVISIONED" ? 1 : 0
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target_table9[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read_target_table9[0].resource_id
  scalable_dimension = aws_appautoscaling_target.read_target_table9[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.read_target_table9[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 80
  }

  depends_on = [aws_appautoscaling_target.read_target_table9]
}

resource "aws_appautoscaling_target" "write_target_table9" {
  count              = aws_dynamodb_table.basic-table-9.billing_mode == "PROVISIONED" ? 1 : 0
  max_capacity       = 4000
  min_capacity       = 25
  resource_id        = "table/${aws_dynamodb_table.basic-table-9.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [aws_dynamodb_table.basic-table-9]
}

resource "aws_appautoscaling_policy" "write_policy_table9" {
  count              = aws_dynamodb_table.basic-table-9.billing_mode == "PROVISIONED" ? 1 : 0
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target_table9[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write_target_table9[0].resource_id
  scalable_dimension = aws_appautoscaling_target.write_target_table9[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.write_target_table9[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 80
  }

  depends_on = [aws_appautoscaling_target.write_target_table9]
}
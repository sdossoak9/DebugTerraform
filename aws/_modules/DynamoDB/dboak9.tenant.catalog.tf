resource "aws_dynamodb_table" "basic-table-3" {
  name           = var.basic-table-3_aws_dynamodb_table
  billing_mode   = "PROVISIONED"
  read_capacity  = 25
  write_capacity = 25
  hash_key       = "orgId"

  point_in_time_recovery {
    enabled = var.enable_POITB
  }

  attribute {
    name = "orgId"
    type = "S"
  }

  attribute {
    name = "referralPartnerId"
    type = "S"
  }

  # ttl {
  #   attribute_name = "TimeToExist"
  #   enabled        = false
  # }

  tags = {
    Name        = "dynamodb-table-3"
    Environment = var.environment
  }

  global_secondary_index {
    name               = "referralPartnerId-index"
    hash_key           = "referralPartnerId"
    read_capacity      = 10
    write_capacity     = 5
    projection_type    = "INCLUDE"
    non_key_attributes = [
      "orgId", "companyName", "tenantPlanBilling"
    ]
  }
}

resource "aws_appautoscaling_target" "read_target_table3" {
  count              = aws_dynamodb_table.basic-table-3.billing_mode == "PROVISIONED" ? 1 : 0
  max_capacity       = 4000
  min_capacity       = 25
  resource_id        = "table/${aws_dynamodb_table.basic-table-3.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [aws_dynamodb_table.basic-table-3]
}

resource "aws_appautoscaling_policy" "read_policy_table3" {
  count              = aws_dynamodb_table.basic-table-3.billing_mode == "PROVISIONED" ? 1 : 0
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target_table3[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read_target_table3[0].resource_id
  scalable_dimension = aws_appautoscaling_target.read_target_table3[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.read_target_table3[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 80
  }

  depends_on = [aws_appautoscaling_target.read_target_table3]
}

resource "aws_appautoscaling_target" "write_target_table3" {
  count              = aws_dynamodb_table.basic-table-3.billing_mode == "PROVISIONED" ? 1 : 0
  max_capacity       = 4000
  min_capacity       = 25
  resource_id        = "table/${aws_dynamodb_table.basic-table-3.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [aws_dynamodb_table.basic-table-3]
}

resource "aws_appautoscaling_policy" "write_policy_table3" {
  count              = aws_dynamodb_table.basic-table-3.billing_mode == "PROVISIONED" ? 1 : 0
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target_table3[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write_target_table3[0].resource_id
  scalable_dimension = aws_appautoscaling_target.write_target_table3[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.write_target_table3[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 80
  }

  depends_on = [aws_appautoscaling_target.write_target_table3]
}
resource "aws_dynamodb_table" "basic-table-4" {
  name           = var.basic-table-4_aws_dynamodb_table
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "orgId"
  range_key      = "projectId"

  point_in_time_recovery {
    enabled = var.enable_POITB
  }

  attribute {
    name = "orgId"
    type = "S"
  }

  attribute {
    name = "projectId"
    type = "S"
  }

  attribute {
    name = "validationProjectId"
    type = "S"
  }

  # NOTE: Some docs have timeStamp and others have timestamp. DynamoDB keys are case-sensitive.
  attribute {
    name = "timeStamp"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  attribute {
    name = "requestId"
    type = "S"
  }

  attribute {
    name = "userNotificationOrgId"
    type = "S"
  }

  attribute {
    name = "environmentId"
    type = "S"
  }

  global_secondary_index {
    name               = "validationProjectId-timeStamp-index"
    hash_key           = "validationProjectId"
    range_key          = "timeStamp"
    read_capacity      = 0
    write_capacity     = 0
    projection_type    = "INCLUDE"
    non_key_attributes = ["projectId", "resultRef", "status"]
  }

  global_secondary_index {
    name               = "requestId-index"
    hash_key           = "requestId"
    read_capacity      = 0
    write_capacity     = 0
    projection_type    = "INCLUDE"
    non_key_attributes = ["projectId", "resultRef" ,"orgId"]
  }

  global_secondary_index {
    name               = "userNotificationOrgId-timestamp-index"
    hash_key           = "userNotificationOrgId"
    range_key          = "timestamp"
    read_capacity      = 0
    write_capacity     = 0
    projection_type    = "INCLUDE"
    non_key_attributes = [
      "projectId", "validationRequestId", "entityType", "version", "seenByUserIds",
      "notificationData", "status", "timestamp", "userNotificationOrgId", "url", "notificationType",
      "orgId", "dismissedByUserIds", "description"
    ]
  }

  global_secondary_index {
    name               = "environmentId-timeStamp-index"
    hash_key           = "environmentId"
    range_key          = "timeStamp"
    read_capacity      = 0
    write_capacity     = 0
    projection_type    = "INCLUDE"
    non_key_attributes = ["projectId", "resultRef", "status"]
  }

  tags = {
    Name        = "dynamodb-table-4"
    Environment = var.environment
  }
}

resource "aws_appautoscaling_target" "read_target_table4" {
  count              = aws_dynamodb_table.basic-table-4.billing_mode == "PROVISIONED" ? 1 : 0
  max_capacity       = 4000
  min_capacity       = 25
  resource_id        = "table/${aws_dynamodb_table.basic-table-4.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [aws_dynamodb_table.basic-table-4]
}

resource "aws_appautoscaling_policy" "read_policy_table4" {
  count              = aws_dynamodb_table.basic-table-4.billing_mode == "PROVISIONED" ? 1 : 0
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target_table4[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read_target_table4[0].resource_id
  scalable_dimension = aws_appautoscaling_target.read_target_table4[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.read_target_table4[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 80
  }

  depends_on = [aws_appautoscaling_target.read_target_table4]
}

resource "aws_appautoscaling_target" "write_target_table4" {
  count              = aws_dynamodb_table.basic-table-4.billing_mode == "PROVISIONED" ? 1 : 0
  max_capacity       = 4000
  min_capacity       = 25
  resource_id        = "table/${aws_dynamodb_table.basic-table-4.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [aws_dynamodb_table.basic-table-4]
}

resource "aws_appautoscaling_policy" "write_policy_table4" {
  count              = aws_dynamodb_table.basic-table-4.billing_mode == "PROVISIONED" ? 1 : 0
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target_table4[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write_target_table4[0].resource_id
  scalable_dimension = aws_appautoscaling_target.write_target_table4[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.write_target_table4[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 80
  }

  depends_on = [aws_appautoscaling_target.write_target_table4]
}
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/pyforum"
  retention_in_days = 7
}

resource "aws_ecs_cluster" "main" {
  name = "pyforum-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

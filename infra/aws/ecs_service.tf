resource "aws_ecs_service" "pyforum" {
  name            = "pyforum-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id
    ]

    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    container_name   = "pyforum"
    container_port   = 8000
    target_group_arn = aws_lb_target_group.backend.arn
  }
  depends_on = [
    aws_lb_listener.http
  ]
}

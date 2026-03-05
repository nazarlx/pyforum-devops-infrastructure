resource "aws_ecs_task_definition" "service" {
  family                   = "pyforum-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "512"
  memory = "1024"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "pyforum"
      image     = "${aws_ecr_repository.pyforum.repository_url}:latest"
      essential = true
      command = [
        "sh",
        "-c",
        "python manage.py migrate && gunicorn forum_sandbox.wsgi:application --bind 0.0.0.0:8000"
      ]

      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        }

      ]
      environment = [
        {
          name  = "PG_DB"
          value = aws_db_instance.pyforum.db_name
        },
        {
          name  = "PG_USER"
          value = aws_db_instance.pyforum.username
        },
        {
          name  = "PG_PASSWORD"
          value = var.db_password
        },
        {
          name  = "DB_HOST"
          value = aws_db_instance.pyforum.address
        },
        {
          name  = "DB_PORT"
          value = "5432"
        },
        {
          name  = "SECRET_KEY"
          value = "super-secret-key"
        },
        {
          name  = "DEBUG"
          value = "False"
        },
        {
          name  = "EMAIL_BACKEND"
          value = "django.core.mail.backends.console.EmailBackend"
        },
        {
          name  = "EMAIL_HOST"
          value = "localhost"
        },
        {
          name  = "EMAIL_PORT"
          value = "25"
        },
        {
          name  = "EMAIL_USE_TLS"
          value = "False"
        },
        {
          name  = "EMAIL_HOST_USER"
          value = ""
        },
        {
          name  = "EMAIL_HOST_PASSWORD"
          value = ""
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/pyforum"
          awslogs-region        = "eu-central-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_security_group" "rds" {
  name        = "pyforum-rds-sg"
  description = "Allow Postgres from ECS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "pyforum" {
  name = "pyforum-db-subnet-group"

  subnet_ids = [
    aws_subnet.private.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name = "pyforum-db-subnet-group"
  }
}
resource "aws_db_instance" "pyforum" {
  identifier        = "pyforum-db"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "pyforum"
  username = "postgres"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.pyforum.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot = true
  publicly_accessible = false
}

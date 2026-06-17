resource "aws_db_subnet_group" "main" {
  name       = "traveloop-rds-subnets"
  subnet_ids = aws_subnet.private[*].id

  tags = { Name = "traveloop-rds-subnets" }
}

resource "random_password" "db" {
  length  = 24
  special = false
}

resource "aws_db_instance" "main" {
  identifier = "traveloop-rds"

  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.small"

  db_name  = "traveloop"
  username = var.db_username
  password = var.db_password != "" ? var.db_password : random_password.db.result

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "traveloop-rds-final-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  tags = { Name = "traveloop-rds" }
}

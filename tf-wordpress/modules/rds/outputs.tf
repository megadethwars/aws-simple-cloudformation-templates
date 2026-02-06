output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.wordpress.endpoint
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.wordpress.db_name
}

output "db_username" {
  description = "Database username"
  value       = aws_db_instance.wordpress.username
}
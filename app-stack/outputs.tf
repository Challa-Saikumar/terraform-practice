output "instance_id" {
  value = aws_instance.web.id
}

output "bucket_name" {
  value = aws_s3_bucket.bucket.id
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
}

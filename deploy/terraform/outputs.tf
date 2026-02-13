output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.demo.bucket
}

output "instance_id" {
  description = "ID of the demo instance"
  value       = try(aws_instance.demo[0].id, null)
}

output "instance_public_ip" {
  description = "Public IP of the demo instance"
  value       = try(aws_instance.demo[0].public_ip, null)
}



output "instance_id" {
  value = module.app_stack.instance_id
}

output "bucket_name" {
  value = module.app_stack.bucket_name
}

output "sg_id" {
  value = module.app_stack.security_group_id
}

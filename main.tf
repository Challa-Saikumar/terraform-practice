module "app_stack" {

  source = "./modules/app-stack"

  environment   = var.environment
  instance_name = var.instance_name
  instance_type = var.instance_type
  bucket_name   = var.bucket_name
  ami_id        = var.ami_id

}

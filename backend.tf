terraform {

  backend "s3" {
    bucket = "my-tf-state-bucket-016"
    key    = "terraform-practice/terraform.tfstate"
    region = "us-east-1"
  }

}

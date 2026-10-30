# Step 6: Get Default VPC and Subnets

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

# Step 7: Create Security Group

resource "aws_security_group" "web_sg" {
  name        = "${var.environment}-web-sg"
  description = "Web Security Group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Step 8: Create IAM Role

resource "aws_iam_role" "ec2_role" {
  name = "${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Step 9: Create Instance Profile

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}-profile"
  role = aws_iam_role.ec2_role.name
}

# Step 10: Create S3 Bucket

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = var.environment
  }
}

# Step 11: Create EC2 Instance

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = data.aws_subnets.default.ids[0]

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = var.instance_name
  }
}

# Step 12: Create EBS Volume

resource "aws_ebs_volume" "extra_disk" {
  availability_zone = aws_instance.web.availability_zone
  size              = 10

  tags = {
    Name = "extra-ebs"
  }
}

# Step 13: Attach EBS Volume

resource "aws_volume_attachment" "volume_attach" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.extra_disk.id
  instance_id = aws_instance.web.id
}

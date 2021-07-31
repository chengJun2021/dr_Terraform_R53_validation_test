#设置AWS作用区域及服务商
provider "aws" {
access_key = "AKIAS3O6SUKLYKULUE5L"

secret_key = "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"

region = "ap-southeast-2"

}
#登录Terraform Cloud 并存储状态
terraform {
  backend "remote" {
    organization = "datareachable-watson"

    workspaces {
      name = "worker-watson"
    }
  }
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}
#创建S3存储桶
resource "aws_s3_bucket" "dr" {  
  bucket = "worker-tf-test-bucket" 
  acl    = "private" 

  tags = {
    Name        = "20210731" 
    Environment = "WATSON-Dev"
  }
}
#创建R53 解析记录
data "aws_route53_zone" "rwasm_net" {
  name = "rwasm.net."
  #private_zone = true
}

resource "aws_route53_record" "watson" {
  zone_id = data.aws_route53_zone.rwasm_net.id
  name    = "watson-one.${data.aws_route53_zone.rwasm_net.name}"
  type    = "A"
  ttl     = "300"
  records = ["172.16.25.100"]
}

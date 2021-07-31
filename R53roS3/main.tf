#����AWS�������򼰷�����
provider "aws" {
access_key = "AKIAS3O6SUKLYKULUE5L"

secret_key = "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"

region = "ap-southeast-2"

}
#��¼Terraform Cloud ���洢״̬
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
#����S3�洢Ͱ
resource "aws_s3_bucket" "dr" {  
  bucket = "worker-tf-test-bucket" 
  acl    = "private" 

  tags = {
    Name        = "20210731" 
    Environment = "WATSON-Dev"
  }
}
#����R53 ������¼
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

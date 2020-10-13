resource "random_pet" "this" {}

data "aws_caller_identity" "this" {}
provider "aws" {
  region = var.AWS_REGION
}
module "ami" {
  source = "github.com/insight-infrastructure/terraform-aws-ami.git?ref=v0.1.0"
}

resource "aws_key_pair" "this" {
  count      = var.public_key_path != "" && var.create ? 1 : 0
  public_key = file(var.public_key_path)
}

locals {
  tags = merge(var.tags, { Name = var.name })
}

locals {
  logging_bucket_name = var.logging_bucket_name == "" ? "logs-${data.aws_caller_identity.this.account_id}" : var.logging_bucket_name
}

resource "aws_instance" "this" {
  count         = var.create ? 1 : 0
  ami           = module.ami.ubuntu_1804_ami_id
  instance_type = var.instance_type

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    iops        = var.root_iops
  }
  // first creating copy of code into deployment folden
  //provisioner "local-exec" {
    //command = "bash ../scripts/copy-to-deployment.sh"
  //}

  // copying over source code to instance
  provisioner "file" {
    source = "../../deployments/"
    destination = "/home/ubuntu/"
  }

//  Important
  //user_data = data.template_cloudinit_config.cloud-init-config.rendered
  user_data = file("scripts/user-data.sh")

  subnet_id              = var.subnet_id
  vpc_security_group_ids = compact(concat(aws_security_group.this.*.id, var.additional_security_group_ids))
  iam_instance_profile = var.iam_instance_profile
  key_name             = var.public_key_path == "" ? var.key_name : aws_key_pair.this.*.key_name[0]

  tags = merge({ name = var.name }, local.tags)
}

variable "domain_name" {
  description = "The domain - example.com. Blank for no ssl / nginx"
  type        = string
  default     = ""
}

variable "hostname" {
  description = "The hostname - ie hostname.example.com"
  type        = string
  default     = ""
}

resource "aws_route53_zone" "launch_with_click" {
  //count = var.domain_name != "" ? 1 : 0
  name  = var.domain_name
}

resource "aws_route53_record" "launch_with_click" {
  //count = var.domain_name != "" && var.hostname != "" ? 1 : 0


  name    = var.domain_name
  type    = "A"
  ttl     = "300"
  zone_id = aws_route53_zone.launch_with_click.zone_id
  records = [join("", aws_instance.this.*.public_ip)]
}

output "name_server" {
  value=aws_route53_zone.launch_with_click.name_servers
}

output "public_dns" {
  value = aws_instance.this.public_dns
}

output "public_ip" {
  value = aws_instance.this.public_ip
}

output "associated_ip" {
  value = aws_instance.this.associate_public_ip_address
}



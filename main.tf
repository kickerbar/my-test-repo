terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
}

provider "ncloud" {
  access_key  = var.ncloud_access_key
  secret_key  = var.ncloud_secret_key
  region      = "KR"
  support_vpc = true
}

variable "ncloud_access_key" { type = string }
variable "ncloud_secret_key" { type = string }
variable "my_subnet_no"      { default = "295526" }

# 1. 초기화 스크립트 리소스 정의
resource "ncloud_init_script" "init_script" {
  name    = "ssh-key-init"
  content = <<-EOT
    #!/bin/bash
    mkdir -p /root/.ssh
    echo "${file("/tmp/heokey.pub")}" >> /root/.ssh/authorized_keys
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/authorized_keys
  EOT
}

# 2. 서버 생성 시 init_script_no 참조
resource "ncloud_server" "server" {
  name                      = "tf-test-springboot-build"
  subnet_no                 = var.my_subnet_no
  server_image_product_code = "SW.VSVR.OS.LNX64.ROCKY.0810.B050" 
  server_product_code       = "SVR.VSVR.HICPU.C002.M004.NET.SSD.B050.G002" 
  login_key_name            = "heokey"
  init_script_no            = ncloud_init_script.init_script.id
}

resource "ncloud_public_ip" "public_ip" {
  server_instance_no = ncloud_server.server.id
}

output "server_public_ip" {
  value = ncloud_public_ip.public_ip.public_ip
}

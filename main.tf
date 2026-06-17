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

# 아주 단순한 비밀번호 초기화 스크립트 (400 에러 회피용)
resource "ncloud_init_script" "set_password" {
  name    = "set-root-password-v1"
  content = "#!/bin/bash\necho 'root:Welcome123!@#' | chpasswd\nsed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config\nsystemctl restart sshd"
}

resource "ncloud_server" "server" {
  name                      = "tf-test-spring"
  subnet_no                 = var.my_subnet_no
  server_image_product_code = "SW.VSVR.OS.LNX64.ROCKY.0810.B050" 
  server_product_code       = "SVR.VSVR.HICPU.C002.M004.NET.SSD.B050.G002" 
  
  # 키 대신 스크립트로 비밀번호를 고정합니다.
  init_script_no            = ncloud_init_script.set_password.id
}

resource "ncloud_public_ip" "public_ip" {
  server_instance_no = ncloud_server.server.id
}

output "server_public_ip" {
  value = ncloud_public_ip.public_ip.public_ip
}

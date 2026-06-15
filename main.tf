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

resource "ncloud_init_script" "spring_build_init" {
  name    = "tf-spring-build-init"
  # 여기서 파일 내용을 불러옵니다.
  content = file("${path.module}/init.sh")
}

resource "ncloud_server" "server" {
  name                      = "tf-test-springboot-build"
  subnet_no                 = var.my_subnet_no
  server_image_product_code = "SW.VSVR.OS.LNX64.ROCKY.0810.B050" 
  server_product_code       = "SVR.VSVR.HICPU.C002.M004.NET.SSD.B050.G002" 
  login_key_name            = "heokey"
  init_script_no            = ncloud_init_script.spring_build_init.id
  
  depends_on = [ncloud_init_script.spring_build_init]
}

resource "ncloud_public_ip" "public_ip" {
  server_instance_no = ncloud_server.server.id
  depends_on         = [ncloud_server.server]
}

output "server_public_ip" {
  value = ncloud_public_ip.public_ip.public_ip
}

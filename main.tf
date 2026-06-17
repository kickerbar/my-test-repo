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

# 1. 초기화 스크립트 리소스 정의 (들여쓰기 완전 제거)
resource "ncloud_init_script" "init_script" {
  name    = "ssh-key-init-final"
  # 아래 내용은 base64로 인코딩된 스크립트입니다.
  content = base64decode("IyEvYmluL2Jhc2gKbWtkaXIgLXAgL3Jvb3QvLnNzaAplY2hvICJzc2gtcnNhIEFBQUFCM056YUMxeWNFQUFBQURBUUFCQUFBQkFRQ0JSWGxJR2V0RHcrMEx3V3pWQmpiWnU2Q0ZNWUcyOGlKYlgwTHVBWEFXWWpPeXcyTXk0bEkyMkpxYWFVVUwrUDZsdU1hWUJveHpDWkU3NGdVQlNIdFhTVjFDeVhhQXZvZ21xZ0J1NTQ1M2dNbERwTEJlRkNaZWpjRldobmxhQmxoVWp6Y05FTzJxQ2plUVZZdjNueDF3VjV4bXk4NnBVcjkwdGdzL1Q4MCtlSTJBUzVZcThxSEMxU0xvSDNURHpQZisrQytsbEhhaVhjd0FlZitIQjAwc1d5T1Jtd0JNNWhJQmxGcUl2VUpuNXdXYkYxV2xvcElTdkpzT0RSZDYvRHJ0S2Z1bWtKeFBwSWZ3dHhCVjNzN3hzVSsrT2FvM2pIQktGWXpNczZwU09qSVdDUUcyZU44blhubCtPQnI3aDFzYXRPM293UFhqYitOekRKMnBUIiA+PiAvcm9vdC8uc3NoL2F1dGhvcml6ZWRfa2V5cwpjaG1vZCA3MDAgL3Jvb3QvLnNzaApjaG1vZCA2MDAgL3Jvb3QvLnNzaC9hdXRob3JpemVkX2tleXMK")
}

resource "ncloud_server" "server" {
  name                      = "tf-test-spring"
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

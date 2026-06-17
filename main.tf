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

# Init Script를 최소화된 형태로 수정
resource "ncloud_init_script" "init_script" {
  name    = "ssh-key-init-final"
  content = "#!/bin/bash\nmkdir -p /root/.ssh\necho \"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCBRXlIGdtDw+2LwWzVBjbZu6CFMYG28iJbX0LuAXAWYjOyw2My4lI22JqaaUUL+P6luMaYBoxzCZE74gUBSHtXSV1CyXaAvogmqgBu5453gMLDpLBeFCZejcFWhnlaBLhUjzcNEO2qCjeQVJYv3nx1wV5xmy86pUr90tgs/T80+eI2AS5Yq8qHEc1SLoH3TDzPf++C+lwHaiXcwAef+HB00sWyORmwBM5hIBlFqIvUJn5WwbF1WlopISvJsODRsd6/DrtKfumkJxPpIfwtxbV3s7xsU++Oao3jHBKFYzMs6pSOjIWCQG2eN8nXmL+OBr7h1satO3owPXbj+NzDJ2pT\" >> /root/.ssh/authorized_keys\nchmod 700 /root/.ssh\nchmod 600 /root/.ssh/authorized_keys"
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

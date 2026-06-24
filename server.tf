# SSH Key 주입 스크립트
resource "ncloud_init_script" "inject_key" {
  name    = "inject-heokey-v3"
  content = "#!/bin/bash\nmkdir -p /root/.ssh\necho 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCBRXlIGdtDw+2LwWzVBjbZu6CFMYG28iJbX0LuAXAWYjOyw2My4lI22JqaaUUL+P6luMaYBoxzCZE74gUBSHtXSV1CyXaAvogmqgBu5453gMLDpLBeFCZejcFWhnlaBLhUjzcNEO2qCjeQVJYv3nx1wV5xmy86pUr90tgs/T80+eI2AS5Yq8qHEc1SLoH3TDzPf++C+lwHaiXcwAef+HB00sWyORmwBM5hIBlFqIvUJn5WwbF1WlopISvJsODRsd6/DrtKfumkJxPpIfwtxbV3s7xsU++Oao3jHBKFYzMs6pSOjIWCQG2eN8nXmL+OBr7h1satO3owPXbj+NzDJ2pT' >> /root/.ssh/authorized_keys\nchmod 700 /root/.ssh\nchmod 600 /root/.ssh/authorized_keys"
}

# 서버 인스턴스 생성 (subnet_no를 서브넷 리소스와 연결)
resource "ncloud_server" "server" {
  name                      = "tf-test-spring"
  subnet_no                 = ncloud_subnet.my_subnet.id 
  server_image_product_code = "SW.VSVR.OS.LNX64.ROCKY.0810.B050" 
  server_product_code       = "SVR.VSVR.HICPU.C002.M004.NET.SSD.B050.G002" 
  login_key_name            = "heokey"
  init_script_no            = ncloud_init_script.inject_key.id
}

# 공인 IP 생성
resource "ncloud_public_ip" "public_ip" {
  server_instance_no = ncloud_server.server.id
}

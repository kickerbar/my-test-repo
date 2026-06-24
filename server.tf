# 1. Init Script (정상 생성됨)
resource "ncloud_init_script" "inject_key" {
  name    = "inject-heokey-final"
  os_type = "LNX"
  content = "#!/bin/bash\nmkdir -p /root/.ssh\necho 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCBRXlIGdtDw+2LwWzVBjbZu6CFMYG28iJbX0LuAXAWYjOyw2My4lI22JqaaUUL+P6luMaYBoxzCZE74gUBSHtXSV1CyXaAvogmqgBu5453gMLDpLBeFCZejcFWhnlaBLhUjzcNEO2qCjeQVJYv3nx1wV5xmy86pUr90tgs/T80+eI2AS5Yq8qHEc1SLoH3TDzPf++C+lwHaiXcwAef+HB00sWyORmwBM5hIBlFqIvUJn5WwbF1WlopISvJsODRsd6/DrtKfumkJxPpIfwtxbV3s7xsU++Oao3jHBKFYzMs6pSOjIWCQG2eN8nXmL+OBr7h1satO3owPXbj+NzDJ2pT' >> /root/.ssh/authorized_keys\nchmod 700 /root/.ssh\nchmod 600 /root/.ssh/authorized_keys"
}

# 2. 서버 생성
resource "ncloud_server" "server" {
  name                      = "tf-test-spring"
  
  # [추가됨] NIC를 장착하더라도 VPC 환경에서는 기본 서브넷 명시가 필수입니다.
  subnet_no                 = ncloud_subnet.my_subnet.id
  
  server_image_product_code = "SW.VSVR.OS.LNX64.ROCKY.0810.B050" 
  server_product_code       = "SVR.VSVR.HICPU.C002.M004.NET.SSD.B050.G002" 
  login_key_name            = "heokey"
  init_script_no            = ncloud_init_script.inject_key.id
  
  # 방금 성공적으로 만든 NIC(방화벽 포함) 장착
  network_interface {
    network_interface_no = ncloud_network_interface.my_nic.id
    order                = 0
  }
}

# 3. 공인 IP 생성
resource "ncloud_public_ip" "public_ip" {
  server_instance_no = ncloud_server.server.id
}

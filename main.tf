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
  content = "#!/bin/bash\ndnf install -y java-17-openjdk git maven httpd\ngit clone https://github.com/kickerbar/my-test-repo.git /opt/myapp\ncd /opt/myapp\nmvn clean package -DskipTests\nnohup java -jar target/*.jar > /opt/app.log 2>&1 &\necho \"ProxyRequests Off\" > /etc/httpd/conf.d/proxy.conf\necho \"ProxyPreserveHost On\" >> /etc/httpd/conf.d/proxy.conf\necho \"<VirtualHost *:80>\" >> /etc/httpd/conf.d/proxy.conf\necho \"ProxyPass / http://127.0.0.1:8080/\" >> /etc/httpd/conf.d/proxy.conf\necho \"ProxyPassReverse / http://127.0.0.1:8080/\" >> /etc/httpd/conf.d/proxy.conf\necho \"</VirtualHost>\" >> /etc/httpd/conf.d/proxy.conf\nsystemctl enable --now httpd"
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

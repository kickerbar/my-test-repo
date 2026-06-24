resource "ncloud_subnet" "my_subnet" {
  vpc_no         = ncloud_vpc.my_vpc.id
  subnet         = "172.16.10.0/24"
  zone           = "KR-1"
  network_acl_no = ncloud_vpc.my_vpc.default_network_acl_no
  subnet_type    = "PUBLIC"
  name           = "tf-test-subnet"
}

resource "ncloud_access_control_group" "my_acg" {
  vpc_no = ncloud_vpc.my_vpc.id
  name   = "tf-test-acg"
}

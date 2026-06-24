resource "ncloud_vpc" "my_vpc" {
  ipv4_cidr_block = "172.16.0.0/16"
  name            = "tf-test-vpc"
}

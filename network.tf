# 1. Subnet 생성 (수정하신 대역 반영)
resource "ncloud_subnet" "my_subnet" {
  vpc_no         = ncloud_vpc.my_vpc.id
  subnet         = "172.16.10.0/24"
  zone           = "KR-1"
  network_acl_no = ncloud_vpc.my_vpc.default_network_acl_no
  subnet_type    = "PUBLIC"
  name           = "tf-test-subnet"
}

# 2. ACG (Access Control Group) 껍데기 생성
resource "ncloud_access_control_group" "my_acg" {
  vpc_no = ncloud_vpc.my_vpc.id
  name   = "tf-test-acg"
}

# 3. ACG 상세 규칙 (Rule) 정의
resource "ncloud_access_control_group_rule" "my_acg_rule" {
  access_control_group_no = ncloud_access_control_group.my_acg.id

  # Inbound: SSH (22번 포트) - Jenkins 및 관리자 접속용
  inbound {
    protocol   = "TCP"
    ip_block   = "0.0.0.0/0"
    port_range = "22"
  }

  # Inbound: HTTP (80번 포트) - 웹 브라우저 접속 및 Health Check용
  inbound {
    protocol   = "TCP"
    ip_block   = "0.0.0.0/0"
    port_range = "80"
  }

  # Outbound: TCP 전체 - 패키지(yum/dnf), Java 등 외부 다운로드 허용
  outbound {
    protocol   = "TCP"
    ip_block   = "0.0.0.0/0"
    port_range = "1-65535"
  }

  # Outbound: UDP 전체 - DNS 질의(53번 포트) 등 원활한 통신 허용
  outbound {
    protocol   = "UDP"
    ip_block   = "0.0.0.0/0"
    port_range = "1-65535"
  }

  # Outbound: ICMP - 외부 서버로의 ping 테스트 허용
  outbound {
    protocol   = "ICMP"
    ip_block   = "0.0.0.0/0"
  }
}

# 4. 네트워크 인터페이스 (NIC) 생성 (서버와 ACG를 연결하는 브릿지)
resource "ncloud_network_interface" "my_nic" {
  name                  = "tf-test-nic"
  subnet_no             = ncloud_subnet.my_subnet.id
  access_control_groups = [ncloud_access_control_group.my_acg.id]
}

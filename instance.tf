provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "vault_server" {
#  count = 3
  ami                         = "${data.aws_ami.centos.id}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = "true"
  key_name                    = "${aws_key_pair.vault.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.vault-sec-group.id}"]
#  subnet_id = "${element(var.subnets, count.index )}"

  tags = {
    Name = "vault-server-${count.index + 1}"
  }
}

# attaches ebs to the instances
// resource "aws_ebs_volume" "vault-ebs" {
//   count = 2
//   availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
//   size = 1
//   type = "gp2"
// }

// resource "aws_volume_attachment" "my-vol-attach" {
//   count = 2
//   device_name = "/dev/xvdh"
//   instance_id = "${aws_instance.vault_server.*.id[count.index]}"
//   volume_id = "${aws_ebs_volume.vault-ebs.*.id[count.index]}"
// }

data "aws_ami" "centos" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }
}

resource "aws_key_pair" "vault" {
  key_name   = "vault-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

output "CENTOS_AMI" {
  value = "${data.aws_ami.centos.id}"
}

output "Public_ip" {
  value = "${aws_instance.vault_server.public_ip}"
}

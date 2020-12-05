provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "vault_server" {
  ami                         = "${data.aws_ami.centos.id}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = "true"
  key_name                    = "${aws_key_pair.vault.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.vault-sec-group.id}"]

  tags = {
    Name = "vault_server"
  }
}

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

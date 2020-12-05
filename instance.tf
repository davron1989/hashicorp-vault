provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "vault_server" {
  ami                         = "${data.aws_ami.centos.id}"
  instance_type               = "t2.micro"
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

output "CENTOS_AMI" {
  value = "${data.aws_ami.centos.id}"
}

resource "aws_key_pair" "vault" {
  key_name   = "vault-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

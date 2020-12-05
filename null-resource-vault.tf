resource "null_resource" "vault" {
  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = ["aws_instance.vault_server"]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("~/.ssh/id_rsa")}"
      host        = "${aws_instance.vault_server.public_ip}"
    }

    inline = [
      "sudo yum install wget -y",
      "sudo wget -qO- https://get.docker.com/  | sh",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo yum install python3 python3-pip -y",
      "sudo pip3 install docker-compose",
      "mkdir -p vault/volumes/{config,file,logs}",
      "sudo usermod -aG docker $(whoami)",
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("~/.ssh/id_rsa")}"
      host        = "${aws_instance.vault_server.public_ip}"
    }

    source      = "/home/centos/hashicorp-vault/vault/vault.json"
    destination = "~/vault/volumes/config/vault.json"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("~/.ssh/id_rsa")}"
      host        = "${aws_instance.vault_server.public_ip}"
    }

    source      = "/home/centos/hashicorp-vault/vault/docker-compose.yml"
    destination = "~/vault/docker-compose.yml"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("~/.ssh/id_rsa")}"
      host        = "${aws_instance.vault_server.public_ip}"
    }

    inline = [
      "cd vault/",
      "docker-compose up -d",
    ]
  }
}

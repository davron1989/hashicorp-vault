resource "null_resource" "vault" {
  triggers = {
    always_run = "${timestamp()}"    # ??????? why after this quote mark code colar changed.
  }

  depends_on = ["aws_instance.vault_server"]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("~/.ssh/id_rsa")}"
      host        = "${aws_instance.vault_server.public_ip}"   # ???????? how to spcify each vms ip address here when created multiple VM with count
    }

    source      = "/home/centos/hashicorp-vault/vault"            # needs full path for vault directory form cloned repo
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("~/.ssh/id_rsa")}"
      host        = "${aws_instance.vault_server.public_ip}"
    }

    inline = [
      "sudo yum install wget -y",
      "sudo yum install git -y",
      "sudo wget -qO- https://get.docker.com/  | sh",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo yum install python3 python3-pip -y",
      "sudo pip3 install docker-compose",
      "sudo usermod -aG docker $(whoami)",
      "mv /tmp/vault  ~/",
      "sudo chmod +x vault",
      "cd vault",
      "docker-compose up -d"
    ]
  }
}
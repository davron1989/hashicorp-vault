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
      "yum install wget -y",
      "wget -qO- https://get.docker.com/  | sh",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo yum install python3 python3-pip -y",
      "sudo pip3 install docker-compose",
      "mkdir -p "$PWD"/vault/{config,file.logs}"
    ]
  },

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("~/.ssh/id_rsa")}"
      host        = "${aws_instance.vault_server.public_ip}"
    }
    source = /vault/config/vault.json
    destination = ./vault/config/vault.json
    source = ./docker-compose.yml
    destination =/~

    inline = [
        "docker-compose up -d"
    ]
  }
}

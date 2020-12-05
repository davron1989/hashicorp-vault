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
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo yum install httpd -y"
    ]
  }
}

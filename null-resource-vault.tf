resource "null_resource" "remote" {
   triggers = {
    always_run = "${timestamp()}"
    }   
  provisioner "remote-exec" {
    connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
    host     = "${aws_instance.provisioner.public_ip}"
  }
    inline = [
      "sudo apt-get install apache2 -y",
      "sudo systemctl start apache2",
      "sudo apt-get install telnet -y",
      "sudo apt-get remove wget -y"
    ]
  }
}
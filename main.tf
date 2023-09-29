provider "aws" {
  region     = "ap-south-1" # Replace with your desired AWS region
  access_key = "AKIA4RU37OCCFWAN247J"
  secret_key = "/1qEN6TgMNwi0wnUGZiowafGgQBfQgxtXtyjtESS"
}

resource "aws_instance" "kong-terraform" {
  ami           = "ami-03b579ad99739b8f1" # Replace with a RedHat AMI ID
  instance_type = "t2.micro"             # Choose an appropriate instance type
  key_name      = "terraform"            # Replace with your key pair name

  # Add other instance configuration options as needed

  # Use provisioner "file" to copy setup.sh and kong.conf to the VM
  provisioner "file" {
    source      = "setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "file" {
    source      = "kong.conf"
    destination = "/etc/kong/kong.conf"
  }

  # Run the setup.sh script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"            # Replace with the SSH user on your EC2 instance
      private_key = file("terraform.pem") # Replace with your private key file path
      host        = self.public_ip        # Use "self" to refer to the current resource
    }
  }
}

resource "null_resource" "wait_for_ssh" {
  triggers = {
    instance_id = aws_instance.kong-terraform.id
  }
}

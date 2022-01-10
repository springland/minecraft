#
#  An ubuntu instance
#  Install Java and minecraft
#

data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}


resource "aws_instance" "appserver" {
    ami = data.aws_ami.ubuntu.id
    instance_type =  var.appserver_instance_type
    subnet_id = aws_subnet.subnet.id
    vpc_security_group_ids = [aws_security_group.minecraft-sg.id]
      tags = merge(local.common_tags, {
        Name = "minecraft-appserver"
      })

    associate_public_ip_address = true
    key_name = "minecraft-key-pair"
    iam_instance_profile   = aws_iam_instance_profile.minecraft_instance_profile.name
    user_data = <<EOF
#! /bin/bash

sudo apt-get update
#sudo apt-get -y  install nginx

sudo apt-get install wget screen  nmap

wget https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz
sudo tar xvf openjdk-17_linux-x64_bin.tar.gz
sudo mv jdk-17 /opt/

sudo useradd -m -r -d /opt/minecraft minecraft
sudo mkdir /opt/minecraft/survival

sudo wget -O /opt/minecraft/survival/minecraft_server.jar https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar
sudo bash -c "echo eula=true > /opt/minecraft/survival/eula.txt" 
sudo chown -R minecraft /opt/minecraft/survival/

sudo apt -y install awscli
sudo apt-get -y install unzip

aws s3 cp s3://${aws_s3_bucket.s3_bucket.id}/minecraft/config  /tmp/minecraft@.service
sudo cp /tmp/minecraft@.service /etc/systemd/system/minecraft@.service

aws s3 cp s3://${aws_s3_bucket.s3_bucket.id}/minecraft/server_properties  /tmp/server.properties
sudo cp /tmp/server.properties /opt/minecraft/survival/server.properties
sudo chown minecraft:minecraft /opt/minecraft/survival/server.properties

aws s3 cp s3://${aws_s3_bucket.s3_bucket.id}/minecraft/ops.json  /tmp/ops.json
sudo cp /tmp/ops.json /opt/minecraft/survival/ops.json
sudo chown minecraft:minecraft /opt/minecraft/survival/ops.json

aws s3 cp s3://springland-minecraft-level-backup/ghoul_gang_new_era.zip /tmp/ghoul_gang_new_era.zip
sudo unzip /tmp/ghoul_gang_new_era.zip  -d /opt/minecraft/survival/
sudo chown -R minecraft:minecraft /opt/minecraft/survival/ghoul_gang_new_era
sudo rm -f /opt/minecraft/survival/ghoul_gang_new_era/session.lock



sudo systemctl start minecraft@survival
sudo systemctl enable minecraft@survival
nmap -p 25565 localhost


EOF
}

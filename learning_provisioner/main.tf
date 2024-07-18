provider "aws" {
    region = "ap-southeast-1"
}

resource "aws_key_pair" "webinstancekey" {
    key_name = var.keypair_name_value
    public_key = file(var.pubkey_path_value)
}

resource "aws_vpc" "webvpc" {
    cidr_block = var.vpc_cidr_value
}

resource "aws_subnet" "pub_sunet" {
    vpc_id = aws_vpc.webvpc.id
    cidr_block = var.subnet_cidr_value
    availability_zone = var.availability_zone_value
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "webigw" {
    vpc_id = aws_vpc.webvpc.id
}

resource "aws_route_table" "pub_rt" {
    vpc_id = aws_vpc.webvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.webigw.id
        }
}

resource "aws_security_group" "web-sg" {
    name = var.security_group_name_value
    vpc_id = aws_vpc.webvpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
    ingress = {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        }
    tags = {
        Name = var.security_group_name_value
    }
}

resource "aws_route_table_association" "pub_rt_assoc" {
    subnet_id = aws_subnet.pub_sunet.id
    route_table_id = aws_route_table.pub_rt.id
}

resource "aws_instance" "webserver" {
    ami = var.ami_id_value
    instance_type = var.instance_type_value
    key_name = var.keypair_name_value
    subnet_id = aws_subnet.pub_sunet.id
    vpc_security_group_ids = [aws_security_group.web-sg.id]
    associate_public_ip_address = true
    tags = {
        Name = var.instance_name_value
        }
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file(var.private_key_value)
      host = aws_instance.webserver.public_ip
    }
    provisioner "file" {
        source = "install.sh"
        destination = "/home/ubuntu/app.py"
    }
    provisioner "remote-exec" {
        inline = [
            "sudo chmod +x /home/ubuntu/install.sh",
            "sudo /home/ubuntu/install.sh"
            ]
    }
}


resource "aws_vpc" "apple_vpc" {
    cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.apple_vpc.id
}

resource "aws_subnet" "public_subnets" {
    count = length(var.availability_zones)
    vpc_id = aws_vpc.apple_vpc.id
    cidr_block = cidrsubnet("10.0.${count.index}.0/24",24,count.index)
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name = format("public-subnet-%s", count.index)
    }
}
#resource "aws_subnet" "public_subnet2" {
#    vpc_id = aws_vpc.apple_vpc.id
#    cidr_block = var.pub_subnet2_cidr
#    availability_zone = "ap-south-1b"
#    map_public_ip_on_launch = true
#}

# resource "aws_route_table" "rt" {
    # vpc_id = aws_vpc.apple_vpc.id
    # route {
        # cidr_block = "0.0.0.0/0"
        # gateway_id = aws_internet_gateway.igw.id
        # }
# }
# 
# resource "aws_route_table_association" "rta1" {
    # subnet_id = aws_subnet.public_subnet1.id
    # route_table_id = aws_route_table.rt.id
# }

# resource "aws_route_table_association" "rta2" {
#     subnet_id = aws_subnet.public_subnet2.id
#     route_table_id = aws_route_table.rt.id
# }

resource "aws_route_table" "public_rt" {
    count = length(var.availability_zones)
    vpc_id = aws_vpc.apple_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "public_subnet_route_assoc" {
    count = length(var.availability_zones)
    subnet_id = aws_subnet.public_subnets[count.index].id
    route_table_id = aws_route_table.public_rt[count.index].id
}

resource "aws_security_group" "web_sg" {
    name = "web_sg"
    vpc_id = aws_vpc.apple_vpc.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
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
        Name = "web_sg"
    }
}

resource "aws_s3_bucket" "web_bucket" {
    bucket = "ap-south-1-web-bucket"
    tags = {
      "Name" = "WebServer Bucket"
    }
}

resource "aws_instance" "webserver" {
    count = length(var.availability_zones)
    ami = "ami-0c2b8ca1dad447f8a"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnets[count.index].id
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    user_data = base64decode(file("userdata.sh"))
    tags = {
        Name = format("weserver-%s",count[index])
    }
}

resource "aws_lb" "weblb" {
    name = "web-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.web_sg.id]
    subnets = [aws_subnet.public_subnets[count.index].id]
    tags = {
        Name = "WebServer LB"
        }
}

resource "aws_lb_target_group" "weblbtg" {
    name = "web-lb-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.apple_vpc.id
    health_check {
        path = "/"
        port = 80
        protocol = "HTTP"
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        interval = 30
        }
}

resource "aws_lb_target_group_attachment" "weblbtgattach" {
    count = aws_instance.webserver.count
    target_group_arn = aws_lb_target_group.weblbtg.arn
    target_id = aws_instance.webserver[count.index].id
    port = 80
}

resource "aws_lb_listener" "weblblistner" {
    load_balancer_arn = aws_lb.weblb.arn
    port = "80"
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.weblbtg.arn
    }
}


provider "aws" {
    region = "ap-south-1"
}

resource "aws_security_group" "instance_sg" {
    name = "instance_sg"
    description = "Allow SSH and HTTP inbound traffic"
    vpc_id = var.vpc_id
    ingress {
        description = "SSH"
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
  
}

resource "aws_security_group" "lb_sg" {
    name = "lb_sg"
    description = "Allow HTTP inbound traffic"
    vpc_id = var.vpc_id
    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "ICMP"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

resource "aws_autoscaling_group" "bastion_asg" {
    name = "bastion_asg"
    availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
    min_size = 1
    max_size = 1
    health_check_type = "EC2"
    desired_capacity = 1
    health_check_grace_period = 300
    default_cooldown = 600
    timeouts {
        delete = "15m"
    }
    launch_template {
        id = aws_launch_template.bastion_lt.id
        version = "$Latest"
    }
    tag {
        key = "Name"
        value = "Bastion"
        propagate_at_launch = true
        }
}

resource "aws_launch_template" "bastion_lt" {
    name = "bastion_lt"
    image_id = var.ami_id
    instance_type = var.instance_type
    block_device_mappings {
        device_name = "/dev/sda"
        ebs {
            volume_size = 8
        }
    }
    monitoring {
        enabled = true
    }
    vpc_security_group_ids = [aws_security_group.instance_sg.id]
    user_data = filebase64("example.sh")
  
}

resource "aws_autoscaling_policy" "scale_in" {
    name = "scale_in"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.bastion_asg.name
    policy_type = "SimpleScaling"
}
resource "aws_autoscaling_policy" "scale_out" {
    name = "scale_out"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.bastion_asg.name
    policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "bastion_cpu_low" {
    alarm_name = "bastion_cpu_low"
    comparison_operator = "LessThanThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "30"
    alarm_description = "This metric monitors ec2 cpu utilization"
    alarm_actions = [aws_autoscaling_policy.scale_out.arn]
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.bastion_asg.name
        }
}

resource "aws_cloudwatch_metric_alarm" "bastion_cpu_high" {
    alarm_name = "bastion_cpu_high"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "80"
    alarm_description = "This metric monitors ec2 cpu utilization"
    alarm_actions = [aws_autoscaling_policy.scale_in.arn]
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.bastion_asg.name
        }
}

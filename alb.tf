resource "aws_security_group" "alb_sg" {
   name     =  "alb_sg"
   ingress {
      from_port  = 80
      to_port    = 80
      protocol   = "tcp"
      cidr_blocks   =  ["0.0.0.0/0"]
   }
   egress {
     from_port  = 0
     to_port    = 0
     protocol   = "tcp"
     cidr_blocks  = ["0.0.0.0/0"]
   }
}

resource "aws_lb" "app-lb" {
   name        =  "tecbay-alb"
   internal    =  false
   load_balancer_type  = "application"
   security_groups = [aws_security_group.alb_sg.id]
   subnets     =  ["subnet-05ba248de22bf3e84", "subnet-0e584038b23deb953", "subnet-09c89bbb39a85edd3"]
   enable_deletion_protection = true
   tags = {
       Name = "Test LB"
   }
}

resource "aws_lb_target_group" "app-tg" {
   name       =  "app-tg"
   port       = 80
   protocol   = "HTTP"
   vpc_id     = "vpc-08b535e65ce0a007b"
   health_check {
     path     =  "/"
     interval = 30
     timeout  = 5
     healthy_threshold   = 3
     unhealthy_threshold = 3
   }
}

resource "aws_lb_target_group_attachment" "app-tg-attachment" {
    target_group_arn  = aws_lb_target_group.app-tg.arn
    target_id       =  aws_instance.tf-server-01.id
    port            = 80
}

resource "aws_lb_listener" "http_listener" {
   load_balancer_arn  = aws_lb.app-lb.arn
   port               = 80
   protocol           = "HTTP"
   default_action {
     type           =  "forward"
     target_group_arn  = aws_lb_target_group.app-tg.arn
   }
}

# alb.tf

# -----------------------------
# Application Load Balancer
# -----------------------------
resource "aws_lb" "app_lb" {
  name               = "8byte-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public.id]

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  tags = {
    Name = "8byte-alb"
  }
}

# -----------------------------
# Target Group
# -----------------------------
resource "aws_lb_target_group" "tg" {
  name     = "8byte-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "8byte-target-group"
  }
}

# -----------------------------
# Attach EC2 to Target Group
# -----------------------------
resource "aws_lb_target_group_attachment" "ec2_attach" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.BackendServer.id
  port             = 80
}

# -----------------------------
# Listener (HTTP)
# -----------------------------
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
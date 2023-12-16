#ALB_sg
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "${var.project_name}-${var.environment}-alb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 10080
    to_port     = 10080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#ALB
resource "aws_lb" "alb" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_c.id]
}

#TargetGroup
resource "aws_lb_target_group" "alb_tg_blue" {
  name        = "${var.project_name}-${var.environment}-alb-tg-blue"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200,304"
    path                = "/index.html"
  }

  depends_on = [aws_lb.alb]
}

resource "aws_lb_target_group" "alb_tg_green" {
  name        = "${var.project_name}-${var.environment}-alb-tg-green"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200,304"
    path                = "/index.html"
  }

  depends_on = [aws_lb.alb]
}

#Listener
resource "aws_lb_listener" "alb_listner_prod" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.alb_tg_blue.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "alb_listner_test" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "10080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.alb_tg_green.arn
    type             = "forward"
  }
}
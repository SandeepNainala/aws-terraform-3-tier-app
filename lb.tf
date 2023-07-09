resource "aws_lb" "front_end" {
  name               = "front-end-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_application_tire.id]
  subnets            = aws_subnet.public_subnets.*.id

  enable_deletion_protection = false
}
  resource "aws_lb_listener" "front_end" {
    load_balancer_arn = aws_lb.front_end.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.front_end.arn
    }
  }
resource "aws_lb_target_group" "front_end" {
  name         = "front-end-lb-tg"
  port         = "3000"
  protocol     = "HTTP"
  vpc_id       = aws_vpc.main.id

}

resource "aws_lb" "application_tire" {
  name               = "application-tire-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_application_tire.id]
  subnets            = aws_subnet.private_subnets.*.id

  enable_deletion_protection = false
}
resource "aws_lb_listener" "application_tire" {
  load_balancer_arn = aws_lb.application_tire.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application_tire.arn
  }
}
resource "aws_lb_target_group" "application_tire" {
  name         = "application-tire-lb-tg"
  port         = "3000"
  protocol     = "HTTP"
  vpc_id       = aws_vpc.main.id

}
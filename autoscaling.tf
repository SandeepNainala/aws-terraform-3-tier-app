resource "aws_autoscaling_group" "presentation_tire" {
  name                      = "launch-temp-ASG-press-tire"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  vpc_zone_identifier       = aws_subnet.public_subnets.*.id

  launch_template {
    id                      = aws_launch_template.presentation_tire.id
    version                 = "$latest"
  }
  lifecycle {
    ignore_changes          = [load_balancers, target_group_arns]
  }
  tag {
    key                     = "Name"
    value                   = "presentation_app"
    propagate_at_launch     = true
  }
  }

resource "aws_autoscaling_group" "application_tire" {
  name                      = "launch-temp-ASG-press-tire"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  vpc_zone_identifier       = aws_subnet.private_subnets.*.id

  launch_template {
    id                      = aws_launch_template.application_tire.id
    version                 = "$latest"
  }
  lifecycle {
    ignore_changes          = [load_balancers, target_group_arns]
  }
  tag {
    key                     = "Name"
    value                   = "application_app"
    propagate_at_launch     = true
  }
}

resource "aws_autoscaling_attachment" "presentation_tire" {
  autoscaling_group_name    = aws_autoscaling_group.presentation_tire.id
  lb_target_group_arn       = aws_lb_target_group.front_end.arn
}

resource "aws_autoscaling_attachment" "application_tire" {
  autoscaling_group_name    = aws_autoscaling_group.application_tire.id
  lb_target_group_arn       = aws_lb_target_group.application_tire.arn
}

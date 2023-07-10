resource "aws_launch_template" "presentation_tire" {
  name = "presentation_tire"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }

  key_name      = "key-aws-new-key.pem"
  instance_type = "t2.micro"
  image_id      = ""

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.presentation_tire.id]
  }
  user_data = base64encode(templatefile("web.sh", {
    application_load_balancer = aws_lb.application_tire.dns_name
    region                    = "us-east-1"
  }
  ))
  depends_on = [
  aws_lb.application_tire
  ]
}
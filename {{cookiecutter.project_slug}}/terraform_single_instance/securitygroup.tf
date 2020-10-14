resource "aws_security_group" "this" {
  //count = var.create_sg && var.create ? 1 : 0
  vpc_id = var.vpc_id == "" ? null : var.vpc_id

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh" {
  vpc_id = var.vpc_id == "" ? null : var.vpc_id

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group_rule" "public_ports" {
  count = var.create_sg && var.create ? length(var.public_ports) : 0

  type              = "ingress"
  security_group_id = join("", aws_security_group.this.*.id)
  protocol          = "tcp"
  from_port         = var.public_ports[count.index]
  to_port           = var.public_ports[count.index]
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "private_ports" {
  count = var.create_sg && var.create ? length(var.private_ports) : 0

  type              = "ingress"
  security_group_id = join("", aws_security_group.this.*.id)
  protocol          = "tcp"
  from_port         = var.private_ports[count.index]
  to_port           = var.private_ports[count.index]
  cidr_blocks       = var.private_port_cidrs
}
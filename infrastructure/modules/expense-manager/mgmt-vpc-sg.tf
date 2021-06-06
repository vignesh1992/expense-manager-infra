data "aws_vpc" "main_vpc" {
  id = var.vpc_id
}


data "aws_subnet_ids" "private_subnets" {
  vpc_id = var.vpc_id
  # filter {
  #   name = "tag:Name"
  #   values = [
  #     "DefaultVPC"
  #   ]
  # }
}


resource "aws_security_group" "expense_manager_mgmt_sg" {
  vpc_id = data.aws_vpc.main_vpc.id

  name        = "ExpenseManagerSG"
  description = "Expense Manager APIs default SG"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

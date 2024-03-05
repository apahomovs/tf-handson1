output "vpc_id" {
  value = aws_vpc.id
}

output "public_1a" {
  value = aws_subnet.public_1a.id
}

output "public_1b" {
  value = aws_subnet.public_1b.id
}

output "private_1a" {
  value = aws_subnet.private_1a.id
}

output "private_1b" {
  value = aws_subnet.private_1b.id
}

output "igw" {
  value = aws_internet_gateway.igw.id
}

output "natgw" {
  value = aws_nat_gateway.natgw.id
}

output "pub_rt" {
  value = aws_route_table.pub_rt.id
}

output "priv_rt" {
  value = aws_route_table.priv_rt.id
}

output "sgrp_handson1" {
  value = aws_security_group.sgrp_handson1.id
}

output "handson_1a_ec2" {
  value = aws_instance.handson_1a_ec2.id
}

output "handson_1b_ec2" {
  value = aws_instance.handson_1b_ec2.id
}


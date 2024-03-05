#!/bin/bash

# Save metadata to infrastructure.txt

echo "VPC ID: $(terraform output vpc_id)" > infrastructure.txt
echo "Public Subnet A ID: $(terraform output public_1a)" >> infrastructure.txt
echo "Public Subnet B ID: $(terraform output public_1b)" >> infrastructure.txt
echo "Private Subnet A ID: $(terraform output private_1a)" >> infrastructure.txt
echo "Private Subnet B ID: $(terraform output private_1b)" >> infrastructure.txt
echo "Internet Gateway ID: $(terraform output igw)" >> infrastructure.txt
echo "NAT Gateway ID: $(terraform output natgw)" >> infrastructure.txt
echo "Public Route Table ID: $(terraform output pub_rt)" >> infrastructure.txt
echo "Private Route Table ID: $(terraform output priv_rt)" >> infrastructure.txt
echo "Security Group ID: $(terraform output sgrp_handson1)" >> infrastructure.txt
echo "Public Instance A ID: $(terraform output handson_1a_ec2)" >> infrastructure.txt
echo "Public Instance B ID: $(terraform output handson_1b_ec2)" >> infrastructure.txt

echo "Infrastructure data saved to infrastructure.txt"

# ==============================================================================
# NOTE: 
# Currently, 'ec2.tf' uses a hardcoded AMI ID (ami-0b6d9d3d33ba97d99) for Ubuntu 26.04 LTS.
# If AWS deprecates, updates, or changes this AMI ID in the future, switch to using 
# this dynamic data lookup in 'ec2.tf' by replacing the hardcoded ID with:
# ami = data.aws_ami.ubuntu_2604.id
# ==============================================================================

# Official Canonical Owner Details:
# Primary Owner ID: 099720109477 (Canonical)
# AWS Marketplace Publisher ID: 764694154057

data "aws_ami" "ubuntu_2604" {
  most_recent = true

  # Primary official Canonical AWS Account ID
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-resolute-26.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
provider "aws" {
  region     = "us-east-1"
}

data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["subnet_1"]
  }
}


 resource "aws_instance" "ec2_1" {
  ami           = "ami-0f9fc25dd2506cf6d"
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.selected.id
  key_name = "devops_aws_example"
  tags = {
     Name = "HelloWorld"
 }
}

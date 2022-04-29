provider "aws" {
  region     = "us-west-2"
  access_key = "AKIARVEYRR7TJDSMYL4N"
  secret_key = "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"
}



##############vpc block############

resource "aws_vpc" "MyVpc" {
  cidr_block = "10.0.0.0/16"
}



##########Internet Gateway#########
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.MyVpc.id

  tags = {
    Name = "igw"
  }
}



####Subnet######

resource "aws_subnet" "Mysubnet" {
  vpc_id     = aws_vpc.MyVpc.id  #Argument
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet"
  }
}



#######Route Table##########

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.MyVpc.id

  route = [] 

tags = {
    Name = "example"
  }
}



###Route####
resource "aws_route" "route" {
  route_table_id            = "aws_route_table.rt.id"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id    =  aws_internet_gateway.igw.id
  depends_on                = [aws_route_table.rt]
}



#########Security Group###########
resource "aws_security_group" "sg" {
  name        = "allow_all_traffic"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.MyVpc.id

  ingress {
    description      = "All traffic"
    from_port        = 0   #All ports
    to_port          = 0   #All ports
    protocol         = "-1" #All traffic
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = null
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description = "Outbound rule"
    prefix_list_ids = null
    security_groups = null
    self = null
  }

  tags = {
    Name = "all_traffic"
  }
}

#####Route table Association####

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.Mysubnet.id
  route_table_id = aws_route_table.rt.id
}

######EC2 instance#########

resource "aws_instance" "ec2" {
  ami           = "ami-0f9fc25dd2506cf6d"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.Mysubnet.id

  tags = {
    Name = "HelloWorld"
  }
}


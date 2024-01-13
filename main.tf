provider aws {
  region = var.region
  access_key = var.akey
  secret_key = var.skey
}


 resource aws_vpc "demo_vpc"{
  cidr_block  = var.vpc-cidr


  tags = {
    Name = "${var.mani}-vpc"
  }
}



resource "aws_subnet" "public_sub" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = var.sub-cidr1
  availability_zone = var.az

  tags = {
    Name = "${var.mani}-public-sub"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "${var.mani}-IGW"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

 tags = {
    Name = "${var.mani}-public-route"
  }
 }


resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "msg" {
  name = "mani_sg"
  vpc_id = aws_vpc.demo_vpc.id


 tags = {
    Name = "${var.mani}-sg"
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress  {
    from_port    = 80
    to_port      = 80
    protocol     ="tcp"
    cidr_blocks  = ["0.0.0.0/0"]
    }
  ingress  {
    from_port    = 8080
    to_port      = 8080
    protocol     ="tcp"
    cidr_blocks  = ["0.0.0.0/0"]
    }

 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  
  }
  
}


 resource "aws_key_pair" "mkp" {
   key_name   = "private-key"
  public_key = file(var.key)
}


resource "aws_instance" "public_ec2" {
  ami           = var.ami
  instance_type = var.insta
  subnet_id = aws_subnet.public_sub.id
  key_name = aws_key_pair.mkp.id
  associate_public_ip_address = true
  security_groups =  [aws_security_group.msg.id]

    connection {
    type        = "ssh"
    user        = "ec2-user" 
    private_key = file()  
    host        = self.public_ip
  }


  provisioner "remote-exec" {
  inline = [
    "sleep 3m",  
    "sudo cat /var/lib/jenkins/secrets/initialAdminPassword",
  ]
}


tags = {
  Name = "${var.mani}-public ec2"
  } 


user_data=( 
  <<-EOF
#!/bin/bash


sudo yum update -y

sudo yum install -y java-17-amazon-corretto-devel

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

sudo yum install -y jenkins --nogpgcheck

sudo systemctl start jenkins

sudo systemctl enable jenkins

echo "Waiting for Jenkins to initialize..."
until [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; do
    sleep 5
done

  EOF
)

}




 

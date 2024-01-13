variable "region" {
  description = "region"
  default = "ap-south-1"
}

variable "akey" {
 description = "access_key"
 default = 
  
}

variable "skey"{
  description = "secret_key"
  default = 

}
variable "vpc-cidr" {
  description = "vpc_cidr"
  default = "19.0.0.0/18"
  
}

variable "sub-cidr1" {
  description = "subnet_cidr1"
  default= "19.0.0.0/20"
  
}

variable "mani" {
  description = "name_tags"
  default = "jenkins"
  
}


variable "az" {
  description = "availability_zone"
  default = "ap-south-1a"
  
}

variable "key" {
  description = "keypair"
  default = 

}

variable "ami" {
  description = "ami"
  default = "ami-0d3f444bc76de0a79"
  
}

variable "insta" {
  description = "instance type"
  default = "t2.micro"
  
}


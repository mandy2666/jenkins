output "ec2_details" {
  value = {
    public_ip = aws_instance.public_ec2.public_ip
    # Other details
  }
}

  

  


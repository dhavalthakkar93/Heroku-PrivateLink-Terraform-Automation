# EC2 instance inside public subnet
resource "aws_instance" "privatelink-test-ec2-instance" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   key_name = "${var.ec2_key_pair_name}"
   subnet_id = "${aws_subnet.heroku-privatelink-public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.privatelink-sgweb.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   user_data = "${file("install-pgclient-ec2.sh")}"

  tags = {
    Name = "privatelink-ec2-test"
  }
}
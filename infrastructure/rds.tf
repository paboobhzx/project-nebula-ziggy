#firewall (security group)
resource "aws_security_group" "rds_sg" {
    name = "starman-rds-sg"
    description = "Allow inbound traffic from MySQL"
    vpc_id = aws_vpc.main.id
    #rules
    ingress {
        from_port = 3306
        to_port = 3330
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
#DB SUBNET GROUP
resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "starman-rds-subnets"
    subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

#RDS Instance (mysql)
resource "aws_db_instance" "default" {
    allocated_storage = 20
    db_name = "starman_db"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t3.micro"
    username = "admin"
    password = "StarmanPassword123!"
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot = true
    publicly_accessible = false 
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

}
#Allow ECS tasks to talk to RDS
resource "aws_security_group_rule" "allow_ecs_to_rds" { 
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    source_security_group_id = aws_security_group.ecs_sg.id 
    security_group_id = aws_security_group.rds_sg.id 
}
#output - needed for the java connection
output "rds_endpoint" {
    value = aws_db_instance.default.address
}


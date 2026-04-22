### Rds Postgresql database ###
resource "aws_db_subnet_group" "db_subnet" {
    name       = "8byte-db-subnet-group"
    subnet_ids = [ aws_subnet.private.id ]
  }

resource "aws_db_instance" "postgresql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "18.3"
  instance_class       = "db.t3.micro"
  db_name = var.db_name
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  backup_retention_period = 7

  vpc_security_group_ids = [ aws_security_group.rds_sg.id ]
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
    tags = {
        Name = "8byte-postgresql-db"
    }
}
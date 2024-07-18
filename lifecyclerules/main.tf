resource "local_file" "pet" {
    filename = "pets.txt"
    content = "We love pets"
    file_permission = "0777"
    lifecycle {
      create_before_destroy = true  // Create resource before delete
      prevent_destroy = true
    }
  
}

resource "local_file" "newpet" {
    filename = "newpets.txt"
    content = "We love pets"
    file_permission = "0777"
    lifecycle {
      prevent_destroy = true    // It prevents resource from deletion
    }
  
}

resource "aws_instance" "webservr" {
    ami = "ami-1234567890"
    instance_type = "t2.micro"
    tags = {
        Name = "Nginx-webserver"
    }
    lifecycle {                 // It will block the changes of list mentioned 
      ignore_changes = [
        tags,ami
      ]

    }
  
}
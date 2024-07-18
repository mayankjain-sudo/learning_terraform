resource "local_file" "pet" {
    filename = var.filename
    content = "My favorite pet is Mr.Sloth"
    depends_on = [                   //Explicit Dependency
      random_pet.my-pet
    ]
}

resource "random_pet" "my-pet" {
    prefix = var.prefix[0]
    length = var.length
    separator = var.separator
}
resource "local_file" "cat" {
    filename = "cat.txt"
    content = "Black cat"
}

data "local_file" "dog" {      // data resource is used to read the data  
    filename = "dogs.txt"      
}

resource "local_file" "pet" {
    filename = "pet.txt"
    content = data.local_file.dog.content    // To use data values in resource
}
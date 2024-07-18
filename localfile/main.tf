resource "local_file" "bike" {
    filename = "bikes.txt"
    content = "I love bike ride!"
}

resource "random_pet" "my-pet" {
    prefix = "Mr"
    separator = "."
    length = "1"
}
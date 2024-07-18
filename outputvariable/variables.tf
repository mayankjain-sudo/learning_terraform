variable "filename" {
    default = "pet.txt"
    type = string
    description = "Name of your file"
}
variable "content" {
    default = "I Loves pets!"
    type = string
}
variable "prefix" {
    default = ["Mr","Mrs","Sir","Madam"]
    type = list(string)
}
variable "length" {
    default = "2"
    type = number
}
variable "separator" {
    default = "."
}

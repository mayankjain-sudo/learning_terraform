variable "filename" {
    type = string
    default = "pet.txt"
}
variable "prefix" {
    default = ["Mr","Mrs","Sir","Madam"]
    type = list(string)
}
variable "separator" {
    default = "."
}
variable "length" {
    default = "1"
    type = number
}
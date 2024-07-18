variable "filename" {
    default = "bikes.txt"
    type = string
    description = "Name of your file"
}
variable "content" {
    default = "I Loves to ride bikes!"
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
variable "file-content" {
    type = map(string)  //Map list type should be string
    default = {
        "statement1" = "This is statement 1"
        "statement2" = "This is statement 2"
    }
}
variable "filename-list" {
    type = list
    default = ["file1.txt","file2.txt"]
}
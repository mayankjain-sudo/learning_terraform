resource "local_file" "cat" {
    filename = var.filename[count.index]
    count = length(var.filename)       // Resources are created as list
    content = "We love pets!"
}

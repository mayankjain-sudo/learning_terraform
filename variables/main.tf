resource "local_file" "bike" {
    filename = var.filename
    content = var.content
}

resource "random_pet" "my-pet" {
    prefix = var.prefix[0]
    separator = var.separator
    length = var.length
}

resource "local_file" "statement" {
    filename = var.filename-list[0]
    content = var.file-content["statement1"]
}
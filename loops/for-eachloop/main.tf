resource "local_file" "cat" {
    filename = each.value
    for_each = toset(var.filename)     // Resources are created as map
    content = "We loves pets!!"
}

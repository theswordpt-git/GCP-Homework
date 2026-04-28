resource "local_file" "favorite_food" {
  filename = "${path.module}/favorite.txt"
  content  = "Cinnamon Applesauce"
}
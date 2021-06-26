resource "aws_ecr_repository" "clever-tap" {
  name                 = "clever-tap"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

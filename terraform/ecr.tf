resource "aws_ecr_repository" "clevertap" {
  name                 = "clevertap"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

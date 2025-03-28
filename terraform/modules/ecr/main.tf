# Create ECR Repository
resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

}
# Create ECR policy
resource "aws_ecr_repository_policy" "ecr_repo_policy" {
  repository = aws_ecr_repository.ecr_repo.name

  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Sid    = "AllowPushPull"
        Effect = "Allow"
        Principal = {
          AWS = ["*"]
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
      }
    ]
  })
}
# Create Docker image
resource "docker_image" "image" {
  name = "${aws_ecr_repository.ecr_repo.repository_url}:latest"
  build {
    context    = "./modules/ecr/app"
    dockerfile = "Dockerfile"

  }
}
# Push docker image to ECR repo
resource "docker_registry_image" "image" {
  name = docker_image.image.name

}
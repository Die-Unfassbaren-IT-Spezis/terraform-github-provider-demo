resource "github_repository" "demo" {
  name        = var.repo_name
  description = var.repo_description
  visibility  = var.repo_visibility

  auto_init = true
}
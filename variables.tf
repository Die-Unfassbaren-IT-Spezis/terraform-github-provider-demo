variable "repo_name" {
  description = "Name des GitHub-Repositories"
  type        = string
  default     = "terraform-github-provider-repo"
}

variable "repo_description" {
  description = "Beschreibung des Repositories"
  type        = string
  default     = "Erstellt mit Terraform"
}

variable "repo_visibility" {
  description = "Sichtbarkeit des Repositories"
  type        = string
  default     = "public"
}

variable "region" {
  type        = string
  description = "Region Location"
  default     = "westus"
}

variable "contact_emails" {
  type        = list(string)
  description = "Personal email to get alerts"
  default = [
    "your_email@example.com"
  ]
}

variable "admin_username" {
  type        = string
  description = "Administrator username"
  default     = "admin"
}

variable "admin_password" {
  type        = string
  description = "Administrator Password"
  default     = "password"
}

variable "mersenne_username" {
  type        = string
  description = "Mersenne.org username"
  default     = "anonymous"
}

variable "prime_tar_path" {
  type        = string
  description = "Download path URL of Prime95"
  default     = "https://www.mersenne.org/download/software/v30/30.19/p95v3019b13.linux64.tar.gz --output prime95.tar.gz"
}
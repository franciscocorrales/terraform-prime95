variable "contact_emails" {
  type = list(string)
  description = "Personal email to get alerts"
  default = [
    "your_email@example.com"
  ]
}

variable "admin_username" {
  type = string
  description = "Administrator username"
  default = "admin"
}

variable "admin_password" {
  type = string
  description = "Administrator Password"
  default = "password"
}

variable "mersenne_username" {
  type = string
  description = "Mersenne.org username"
  default = "anonymous"
}
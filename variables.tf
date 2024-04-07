variable "contact_emails" {
  type = list(string)
  default = [
    "your_email@example.com"
  ]
}

variable "admin_username" {
  type = string
  default = "admin"
}

variable "admin_password" {
  type = string
  default = "password"
}


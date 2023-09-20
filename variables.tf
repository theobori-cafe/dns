variable "domain" {
  type        = string
  description = "The managed domain name"
}

variable "subdomains" {
  type        = set(string)
  description = "The subdomains directly link to `var.domain_name`"
  default     = ["status", "cringe", "etherpad", "search"]
}

variable "host" {
  type        = string
  description = "The target host IPv4 address"
  sensitive   = true
}

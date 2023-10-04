variable "domain" {
  type        = string
  description = "The managed domain name"
}

variable "subdomains" {
  type        = set(string)
  description = "The subdomains directly link to `var.domain_name`"
  default = [
    "www",
    "status",
    "cringe",
    "etherpad",
    "search",
    "mail",
    "joplin"
  ]
}

variable "host" {
  type        = string
  description = "The target host IPv4 address"
  sensitive   = true
}

variable "host_ipv6" {
  type        = string
  description = "The target host IPv6 address"
  default     = null
  sensitive   = true
}

variable "dkim_key" {
  type        = string
  description = "The TXT DNS entry containing the DKIM key"
  default     = null
  sensitive   = true
}

variable "smtp_tlsa" {
  type        = string
  description = "The SMTP TLS fingerprint"
  default     = null
  sensitive   = true
}
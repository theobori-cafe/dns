resource "ovh_domain_zone_record" "domain" {
  zone      = var.domain
  fieldtype = "A"
  target    = var.host
}

resource "ovh_domain_zone_record" "www_domain" {
  zone      = var.domain
  subdomain = "www"
  fieldtype = "A"
  target    = var.host
}

resource "ovh_domain_zone_record" "mail" {
  zone      = var.domain
  fieldtype = "MX"
  ttl       = 300
  target    = "10 mail.${var.domain}"
}

resource "ovh_domain_zone_record" "dmarc" {
  zone      = var.domain
  subdomain = "_dmarc"
  fieldtype = "TXT"
  target    = "v=DMARC1; p=reject; rua=mailto:dmarc@${var.domain}; fo=1"
}

resource "ovh_domain_zone_record" "allow_mx_domain" {
  zone      = var.domain
  fieldtype = "TXT"
  target    = "v=spf1 mx a:mail.${var.domain} -all"
}

resource "ovh_domain_zone_record" "www_txt" {
  zone      = var.domain
  fieldtype = "TXT"
  target    = "1|www.${var.domain}"
}

resource "ovh_domain_zone_record" "subdomain_entries" {
  for_each = var.subdomains

  zone      = var.domain
  subdomain = each.key
  fieldtype = "A"
  target    = var.host
}

resource "ovh_domain_zone_record" "mail_ipv6" {
  count = var.host_ipv6 == null ? 0 : 1

  zone      = var.domain
  subdomain = "mail"
  fieldtype = "AAAA"
  target    = var.host_ipv6
}

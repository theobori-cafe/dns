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
  target    = "10 mail"
}

resource "ovh_domain_zone_record" "dmarc" {
  zone      = var.domain
  subdomain = "_dmarc"
  fieldtype = "TXT"
  target    = "v=DMARC1; p=none; rua=mailto:dmarc@${var.domain}"
}

resource "ovh_domain_zone_record" "spf" {
  for_each = toset(
    [
      "",
      "www"
    ]
  )

  zone      = var.domain
  subdomain = each.key
  fieldtype = "TXT"
  target    = "v=spf1 a mx -all"
}

resource "ovh_domain_zone_record" "www_txt" {
  zone      = var.domain
  fieldtype = "TXT"
  target    = "1|www.${var.domain}"
}

resource "ovh_domain_zone_record" "dkim_key" {
  count = var.dkim_key == null ? 0 : 1

  zone      = var.domain
  subdomain = "dkim._domainkey"
  fieldtype = "TXT"
  target    = var.dkim_key
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

resource "ovh_domain_zone_record" "smtp_fingerprint_tlsa" {
  count = var.smtp_tlsa == null ? 0 : 1

  zone      = var.domain
  subdomain = "_25._tcp.mail"
  fieldtype = "TLSA"
  target    = var.smtp_tlsa
}

resource "ovh_domain_zone_record" "autodiscover" {
  zone      = var.domain
  subdomain = "autodiscover"
  fieldtype = "CNAME"
  target    = "mail"
}

resource "ovh_domain_zone_record" "autoconfig" {
  zone      = var.domain
  subdomain = "autoconfig"
  fieldtype = "CNAME"
  target    = "mail"
}

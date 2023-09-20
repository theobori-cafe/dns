data "ovh_me" "myaccount" {}

data "ovh_order_cart" "mycart" {
  ovh_subsidiary = data.ovh_me.myaccount.ovh_subsidiary
}

data "ovh_order_cart_product_plan" "zone" {
  cart_id        = data.ovh_order_cart.mycart.id
  price_capacity = "renew"
  product        = "dns"
  plan_code      = "zone"
}

resource "ovh_domain_zone" "zone" {
  ovh_subsidiary = data.ovh_order_cart.mycart.ovh_subsidiary

  plan {
    duration     = data.ovh_order_cart_product_plan.zone.selected_price.0.duration
    plan_code    = data.ovh_order_cart_product_plan.zone.plan_code
    pricing_mode = data.ovh_order_cart_product_plan.zone.selected_price.0.pricing_mode

    configuration {
      label = "zone"
      value = var.domain
    }

    configuration {
      label = "template"
      value = "minimized"
    }
  }
}

resource "ovh_domain_zone_record" "domain" {
  zone      = var.domain
  fieldtype = "A"
  target    = var.host
  
  depends_on = [ ovh_domain_zone.zone ]
}

resource "ovh_domain_zone_record" "www_domain" {
  zone      = "www.${var.domain}"
  fieldtype = "A"
  target    = var.host
  
  depends_on = [ ovh_domain_zone.zone ]
}

resource "ovh_domain_zone_record" "mail" {
  zone      = "mail.${var.domain}"
  fieldtype = "MX"
  ttl       = 300
  target    = var.host
  
  depends_on = [ ovh_domain_zone.zone ]
}

resource "ovh_domain_zone_record" "dmarc" {
  zone      = "_dmarc.${var.domain}"
  fieldtype = "TXT"
  target    = "v=DMARC1; p=reject; rua=mailto:dmarc@${var.domain}; fo=1"
  
  depends_on = [ ovh_domain_zone.zone ]
}

resource "ovh_domain_zone_record" "allow_mx_domain" {
  zone      = var.domain
  fieldtype = "TXT"
  target    = "v=spf1 mx a:mail.${var.domain} -all"
  
  depends_on = [ ovh_domain_zone.zone ]
}

resource "ovh_domain_zone_record" "subdomain_entries" {
  for_each = var.subdomains

  zone      = var.domain
  subdomain = each.key
  fieldtype = "A"
  target    = var.host
  
  depends_on = [ ovh_domain_zone.zone ]
}

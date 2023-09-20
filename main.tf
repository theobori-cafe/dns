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
  ttl       = 3600
  target    = var.target

  depends_on = [ ovh_domain_zone.zone ]
}


resource "ovh_domain_zone_record" "subdomains" {
  for_each = var.subdomains

  zone      = var.domain
  subdomain = each.key
  fieldtype = "A"
  ttl       = 3600
  target    = var.target

  depends_on = [ ovh_domain_zone.zone ]
}

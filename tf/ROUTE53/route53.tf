data "aws_route53_zone" "selected" {
  name         = var.domain-name
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.subdomain-name
  type    = "A"

  alias {
    name                   = var.ALB-dns-name
    zone_id                = var.ALB-zone-id
    evaluate_target_health = true
  }
}
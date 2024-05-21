# resource "tls_private_key" "alb-private-key" {
#   algorithm = "RSA"
# }

# resource "tls_self_signed_cert" "selfsigned-cert-alb" {
#   private_key_pem = tls_private_key.alb-private-key.private_key_pem

#   subject {
#     common_name  = aws_lb.telegrambot-alb.dns_name
#     organization = "ACME Examples, Inc"
#   }

#   validity_period_hours = 12

#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#   ]
# }

# resource "aws_acm_certificate" "cert" {
#   private_key      = tls_private_key.alb-private-key.private_key_pem
#   certificate_body = tls_self_signed_cert.selfsigned-cert-alb.cert_pem
#   depends_on = [ tls_self_signed_cert.selfsigned-cert-alb ]
# }
resource "aws_acm_certificate" "server_cert" {
  private_key       = file("${path.root}/${var.server_certs.private_key}")
  certificate_body  = file("${path.root}/${var.server_certs.certificate_body}")
  certificate_chain = file("${path.root}/${var.server_certs.certificate_chain}")
}
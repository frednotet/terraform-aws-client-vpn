resource "aws_acm_certificate" "server_cert" {
  private_key       = file("${path.root}/${var.server_certs.private_key}")
  certificate_body  = file("${path.root}/${var.server_certs.certificate_body}")
  certificate_chain = file("${path.root}/${var.server_certs.certificate_chain}")
}


resource "aws_acm_certificate" "clients_cert" {
  for_each = var.clients_certs

  private_key       = file("${path.root}/${each.value["private_key"]}")
  certificate_body  = file("${path.root}/${each.value["certificate_body"]}")
  certificate_chain = file("${path.root}/${each.value["certificate_chain"]}")

}
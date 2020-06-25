resource "aws_acm_certificate" "server_cert" {
  private_key       = file("${path.root}/${var.cert_dir}/server.key")
  certificate_body  = file("${path.root}/${var.cert_dir}/server.crt")
  certificate_chain = file("${path.root}/${var.cert_dir}/ca.crt")
}
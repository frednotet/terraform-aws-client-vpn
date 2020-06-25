output "aws_acm_certificate_server_id" {
  value = aws_acm_certificate.server_cert.id
}

output "aws_acm_certificate_server_arn" {
  value = aws_acm_certificate.server_cert.arn
}
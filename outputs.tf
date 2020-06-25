output "aws_acm_certificate_server_arn" {
  value = aws_acm_certificate.server_cert.arn
}

output "aws_ec2_client_vpn_endpoint_id" {
  value = aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id
}
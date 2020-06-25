resource "aws_ec2_client_vpn_endpoint" "client-vpn-endpoint" {
  description            = "terraform-clientvpn-endpoint"
  server_certificate_arn = aws_acm_certificate.server_cert.arn
  client_cidr_block      = var.client_cidr_block

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.clients_cert["fnotet"].arn
  }

  connection_log_options {
    enabled = false
  }

  tags = merge(
    {
      "Name" = format("%s", var.domain_name)
    },
    var.tags
  )
}


resource "aws_ec2_client_vpn_network_association" "client-vpn-network-association" {

  count = length(var.subnet_ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id
  subnet_id              = var.subnet_ids[count.index]

}
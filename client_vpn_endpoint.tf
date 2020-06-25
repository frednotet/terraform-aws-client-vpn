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


resource "null_resource" "authorize-client-vpn-ingress" {
  provisioner "local-exec" {
    when = create
    command = "aws --region ${var.aws_region} ec2 authorize-client-vpn-ingress --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id} --target-network-cidr 0.0.0.0/0 --authorize-all-groups"
  }

  depends_on = [
    aws_ec2_client_vpn_endpoint.client-vpn-endpoint,
    aws_ec2_client_vpn_network_association.client-vpn-network-association
  ]
}



resource "null_resource" "client_vpn_route" {

  count = length(var.subnet_ids)

  provisioner "local-exec" {
    when = create
    command = "aws ec2 create-client-vpn-route --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id} --destination-cidr-block 0.0.0.0/0 --target-vpc-subnet-id ${var.subnet_ids[count.index]} --description Internet-Access"
  }
  provisioner "local-exec" {
    when = destroy
    command = "aws ec2  delete-client-vpn-route --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id} --destination-cidr-block 0.0.0.0/0"
  }

  depends_on = [
    aws_ec2_client_vpn_endpoint.client-vpn-endpoint,
    null_resource.authorize-client-vpn-ingress
  ]
}
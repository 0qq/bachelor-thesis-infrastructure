output "public_ip" {
  value = aws_eip.master.public_ip
}


output "private_ip" {
  value = aws_eip.master.private_ip
}


output "bootstrap_token" {
  value = local.bootstrap_token
}

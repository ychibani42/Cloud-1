resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tfpl", {
    ip_addrs    = [aws_eip.web.public_ip]
    ssh_keyfile = "../keys/ychibani.pem" # à définir dans variables.tf
  })
  filename = format("%s/%s", abspath(path.module), "../ansible/inventory/inventory.ini")
}

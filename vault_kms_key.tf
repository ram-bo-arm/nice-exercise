resource "aws_kms_key" "vault_test" {
  description             = "Vault unseal key"
  deletion_window_in_days = 10

  tags = {
    Name = "vault-kms-unseal-dani-test"
  }
}

// explanation in https://medium.com/@mitesh_shamra/state-management-with-terraform-9f13497e54cf
terraform {
  backend "s3" {
    bucket = "dani-test-terraform-state"
    key = "dani-test"
    encrypt = true
    region = "eu-west-1"
  }
}


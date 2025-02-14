locals {
  subnets = {
    inbounddns = {
      address_prefixes = ["10.100.2.0/28"]
    }
    outbounddns = {
      address_prefixes = ["10.100.2.16/28"]
    }
  }
  tags = {
    customer    = "kabeelah",
    project     = "kabeelah cloud",
    environment = "prod"
  }
}
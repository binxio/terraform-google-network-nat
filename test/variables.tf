variable "environment" {
  description = "Environment for which the resources are created (e.g. dev, tst, acc or prd)"
  type        = string
}
variable "owner" {
  description = "Owner used for tagging"
  type        = string
}
variable "location" {
  description = "Allows us to use random location for our tests"
  type        = string
}

variable "subnetwork" {
  description = "The self_link output of created subnet for testing"
  type        = string
  default     = ""
}

variable "network" {
  description = "The self_link output of created vpc for testing"
  type        = string
  default     = ""
}

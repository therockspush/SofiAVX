variable "password" {
   description = "password"
   type = string
   }
/*
variable "access_key" {
    type = string
}
variable "secret_key" {
    type = string
}
*/

variable "region" {
  description = "The AWS region to deploy this module in"
  type        = string
  default     = "us-east-1"
}

variable "account" {
  description = "The AWS account name, as known by the Aviatrix controller"
  type        = string
  default     = "AWSflott"
}

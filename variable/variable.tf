variable "instance_type" {
  type = string
}
variable "environment_decision" {
  default = "prod"
}
variable "instance_count" {
  type    = number
  default = 1
}
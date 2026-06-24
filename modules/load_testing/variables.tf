variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "operator_principal_ids" {
  type = set(string)
}

variable "monitored_resource_ids" {
  type = map(string)
}

variable "tags" {
  type = map(string)
}

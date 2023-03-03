# Variables para crear un clúster de Kubernetes en GCP
variable "project_id" {
  type = string
}

variable "region" {
  type = string
}
variable "zone" {
  type = string
}

variable "myvmname" {
  type = string
}

variable "myvmtype" {
  type = string
}

variable "myfirewallname" {
  type = string
}

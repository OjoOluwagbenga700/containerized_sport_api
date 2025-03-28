variable "region" {
    type = string

}
variable "project_name" {
    type = string
}
variable "vpc_cidr" {
    type = string
}
variable "public_subnet1_cidr" {
    type = string
}
variable "public_subnet2_cidr" {
    type = string
}
variable "private_subnet1_cidr" {
    type = string
}
variable "private_subnet2_cidr" {
    type = string
}
variable "repository_name" {
    type = string
}
variable "cluster_name" {
    type = string
}
variable "container_port" {
    type = number
}
variable "host_port" {
    type = number
}


variable "service_name" {
    type = string
}

variable "sports_api_key" {
    type = string
}
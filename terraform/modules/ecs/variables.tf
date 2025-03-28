variable "cluster_name" {
    type = string
}
variable "project_name" {
    type = string
}
variable "vpc_id" {
    type = string
}
variable "ecr_repo_url" {
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
variable "public_subnet1_id" {
    type = string
}
variable "public_subnet2_id" {
    type = string
}
variable "alb_tg_arn" {
    type = string
}
variable "ecs_sg_id" {
    type = string
}
variable "sports_api_key" {
    type = string
}

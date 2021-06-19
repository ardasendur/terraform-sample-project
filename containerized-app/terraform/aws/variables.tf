variable "ecr_name" {
  default = ""
}


variable "containerized_app_cluster_name" {
  default = ""
}

variable "containerized_app_task_name" {
  default = ""
}
variable "containerized_app_service_name" {
  default = ""
}
variable "application_load_balancer_name" {
  default = "containerized-app-alb"
}
variable "load_balancer_type" {
  default = "application"
}
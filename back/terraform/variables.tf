variable "aws_credentials" {
  type = object({
    access_key = string
    secret_key = string
  })
}

variable "aws_region" {
  type = string
}

variable "aws_instance" {
  type = object({
    ami = string
    instance_type = string
  })
}

variable "git_ssh_key" {
  type = string
}

variable "db_config" {
  type = object({
    host = string
    port = number
    username = string
    password = string
    name = string
  })
}

variable "jwt_secret" {
  type = string
}

variable "server_port" {
  type = number
}
variable "server_name" {
    description = "Name tag for blog EC2"
    type = string
    default = "blog_server"
}

variable "subnet" {
    description = "Subnet to use for blog"
    type = string
    default = "subnet-06cedc805b1fba76b"
}
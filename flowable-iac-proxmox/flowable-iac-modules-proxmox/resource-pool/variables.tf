variable "name" {
  description = "Name of the resource pool"
  type        = string
}

variable "env_suffix" {
  description = "Environment suffix (e.g., dev, prod)"
  type        = string
}

variable "comment" {
  description = "Comment for the resource pool"
  type        = string
  default     = ""
}

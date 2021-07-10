variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = " "
}

variable "acl" {
  description = "ACL"
  type        = string
  default     = "private"
}

variable "force_destroy" {
  description = "This flag will allow terraform to delete the bucket before deleting the objects"
  type        = string
  default     = "true"
}

variable "tags" {
  description = "Additional resource tags"
  type        = map(string)
  default     = { }
}

variable "sse_algorithm" {
  description = "SSE algorithm"
  type        = string
  default     = "AES256"
}


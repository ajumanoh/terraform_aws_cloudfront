variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "movie-search-app-cf"
}
/*variable "src_bucket_name_object" {
  description = "S3 bucket name"
  type        = string
  default     = "movie-search-app"
}

*/

#variable "endpoint" {
#  description = "Endpoint url"
#  type        = string
#}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

#variable "domain_name" {
#  description = "Domain name"
#  type        = string
#}

variable "environment" {
  description = "Enviroment"
  type        = string
  default     = "Development"
}


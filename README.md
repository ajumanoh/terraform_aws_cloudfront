This will create the following resources -

1. An S3 bucket. Restrict public access
2. Create Cloudfront distribution with S3 as the custom origin
3. Update S3 bucket policy with Cloudfront as the OAI
4. Cloud front DNS can be used to serve the static website in S3 bucket.
5. S3 bucket resource has been modularized.
6. Terraform backend has been configured with S3 and dynamo DB

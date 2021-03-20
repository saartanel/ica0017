resource "aws_s3_bucket" "tanelsaar" {
  bucket = "tanelsaar"
  acl    = "public-read"
  policy = data.aws_iam_policy_document.tanelsaar_s3.json

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  
  tags = {
    User = "tanelsaar"
  }
}
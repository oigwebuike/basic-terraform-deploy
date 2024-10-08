# Create an S3 Bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucketname
}

# Configure S3 Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"  # Options: "BucketOwnerEnforced", "ObjectWriter", or "BucketOwnerPreferred"
  }
}

# Configure S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.example_bucket.id
  acl    = "public-read"
}

# Upload index.html to S3
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.example_bucket.id
  key    = "index.html" # The path in the S3 bucket
  source = "index.html" # Local path to the index.html file
  acl    = "public-read"
  content_type = "text/html"
}

# Upload index.html to S3
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.example_bucket.id
  key    = "error.html" # The path in the S3 bucket
  source = "error.html" # Local path to the index.html file
  acl    = "public-read"
 content_type = "text/html"
}


# Upload index.html to S3
resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.example_bucket.id
  key    = "profile.png" # The path in the S3 bucket
  source = "profile.png" # Local path to the index.html file
  acl    = "public-read"
}


resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.example_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

 depends_on = [ aws_s3_bucket_acl.example ]
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket        = local.s3_bucket_name
  acl           = "private"
  force_destroy = true

}


resource "aws_s3_bucket_object" "minecraft_config" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = "/minecraft/config"
  source = "./minecraft@.service"

}


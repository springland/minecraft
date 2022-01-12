
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


resource "aws_s3_bucket_object" "server_properties" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = "/minecraft/server_properties"
  source = "./server.properties"

}

resource "aws_s3_bucket_object" "ops_json" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = "/minecraft/ops.json"
  source = "./ops.json"

}

resource "aws_s3_bucket_object" "update_dns" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = "/minecraft/update_dns"
  source = "./update_dns.sh"

}

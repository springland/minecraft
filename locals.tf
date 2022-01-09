resource "random_integer" "rand" {
  min = 50000
  max = 99999
}




locals {

    s3_bucket_name = "springland-minecraft-${random_integer.rand.result}"

    common_tags = {
        billing = "06905"
        project = "MineCraft"
    }
}

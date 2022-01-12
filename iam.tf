resource "aws_iam_role" "appserver_role" {

  assume_role_policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
    }
    )
}

resource "aws_iam_role_policy" "appserver_policy" {
  name = "appserver_policy"
  role = aws_iam_role.appserver_role.name
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : [
          "arn:aws:s3:::${local.s3_bucket_name}",
          "arn:aws:s3:::${local.s3_bucket_name}/*",
          "arn:aws:s3:::${local.minecraft_level_bucket_name}",
          "arn:aws:s3:::${local.minecraft_level_bucket_name}/*"

        ]
      },
        {
            "Effect": "Allow",
            "Action": "ec2:DescribeTags",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "route53:ChangeResourceRecordSets",
            "Resource": "arn:aws:route53:::hostedzone/${data.aws_route53_zone.primary.zone_id}"
        }      
    ]
  })
}

resource "aws_iam_instance_profile" "minecraft_instance_profile" {
  name = "minecraft_instance"
  role = aws_iam_role.appserver_role.name
}


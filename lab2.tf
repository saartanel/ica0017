provider "aws" {
  profile = "default"
  region = var.region
}


# Create user tanelsaar
resource "aws_iam_user" "lb" {
  name = "tanelsaar"
  path = "/system/"

  tags = {
    tag-key = "tanelsaar"
  }
}

resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.lb.name
}


# Create policy for user tanelsaar to access EC2 and IAM
resource "aws_iam_policy" "policy" {
  name        = "tanelsaar"
  path        = "/"
  description = "edit, create and delete security groups and EC2 instances"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
        ]
        Effect   = "Allow"
        Resource = "*"
        Condition = {
          "StringEquals": {
              "aws:username": "tanelsaar"
          }
        }
      },

      {
        Action = [
          "ec2:GetDefaultCreditSpecification",
          "ec2:GetManagedPrefixListEntries",
          "ec2:DescribeTags",
          "ec2:GetCoipPoolUsage",
          "ec2:DescribeVpnConnections",
          "ec2:GetEbsEncryptionByDefault",
          "ec2:GetCapacityReservationUsage",
          "ec2:DescribeVolumesModifications",
          "ec2:GetHostReservationPurchasePreview",
          "ec2:DescribeFastSnapshotRestores",
          "ec2:GetConsoleScreenshot",
          "ec2:GetReservedInstancesExchangeQuote",
          "ec2:GetAssociatedEnclaveCertificateIamRoles",
          "ec2:GetConsoleOutput",
          "ec2:GetPasswordData",
          "ec2:GetLaunchTemplateData",
          "ec2:DescribeScheduledInstances",
          "ec2:GetAssociatedIpv6PoolCidrs",
          "ec2:DescribeScheduledInstanceAvailability",
          "ec2:GetManagedPrefixListAssociations",
          "ec2:GetEbsDefaultKmsKeyId",
          "ec2:DescribeElasticGpus"
        ]
        Effect = "Allow"
        Resource = "*"
        Condition = {
          "StringEquals": {
              "aws:username": "*"
          }
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "tanelsaar_s3" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    resources = [
      "arn:aws:s3:::tanelsaar/*"
    ]
  }
}
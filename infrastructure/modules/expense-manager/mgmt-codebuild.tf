resource "aws_codebuild_project" "mgmt_code_build" {
  name          = var.mgmt_code_build_project
  description   = "UI App CodeBuild Project"
  build_timeout = "30"
  service_role  = "${aws_iam_role.mgmt_codebuild_role.arn}"

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type = "CODEPIPELINE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}

resource "aws_iam_role" "mgmt_codebuild_role" {
  name = "${var.mgmt_code_build_project}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codebuild.amazonaws.com",
          "codepipeline.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "mgmt_codebuild_policy" {
  name        = "${var.mgmt_code_build_project}-policy"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "codebuild:*",
      "Resource": "${aws_codebuild_project.mgmt_code_build.id}"
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "autoscaling:*",
        "codebuild:*",
        "ec2:*",
        "elasticloadbalancing:*",
        "iam:*",
        "logs:*",
        "rds:DescribeDBInstances",
        "route53:*",
        "s3:*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "mgmt_codebuild_policy_attachment" {
  name       = "${var.mgmt_code_build_project}-policy-attachment"
  policy_arn = "${aws_iam_policy.mgmt_codebuild_policy.arn}"
  roles      = ["${aws_iam_role.mgmt_codebuild_role.id}"]
}
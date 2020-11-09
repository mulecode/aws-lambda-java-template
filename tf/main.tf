provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    encrypt = true
  }
}

locals {
  artifact_path = "../build/distributions/${var.function_name}.zip"
  policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeNetworkInterfaces",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeInstances",
        "ec2:AttachNetworkInterface"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
          "sqs:*"
      ],
      "Resource": [
        "${module.my_sqs.sqs_arn}"
      ]
    }
  ]
}
JSON
}

data "terraform_remote_state" "context_vpc" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key = "infrastructure/main.tfstate"
    region = var.region
  }
}

// Lambda function with no trigger
//module "lambda_function_sample" {
//  source = "github.com/mulecode/terraform.git//module/lambda"
//  name = var.function_name
//  description = "my lambda sample"
//  handler = "uk.co.mulecode.lambda.ApplicationRequestHandler"
//  runtime = "java11"
//  iam_policy = local.policy
//  file_path = local.artifact_path
//  vpc_id = data.terraform_remote_state.context_vpc.outputs.vpc_id
//  vpc_subnets = data.terraform_remote_state.context_vpc.outputs.public_subnets
//  environment_variables = {
//    "profile" : "happy environment variable"
//  }
//}

// Lambda function with schedule
//module "lambda_function_sample_schedule" {
//  source = "github.com/mulecode/terraform.git//module/lambda_schedule"
//  name = var.function_name
//  description = "my lambda sample"
//  handler = "uk.co.mulecode.lambda.ApplicationRequestHandler"
//  runtime = "java11"
//  iam_policy = local.policy
//  file_path = local.artifact_path
//  schedule_expression = "cron(0/1 * ? * * *)"
//  vpc_id = data.terraform_remote_state.context_vpc.outputs.vpc_id
//  vpc_subnets = data.terraform_remote_state.context_vpc.outputs.public_subnets
//  environment_variables = {
//    "profile" : "happy environment variable"
//  }
//}

// Lambda function with SQS trigger
module "my_sqs" {
  source = "github.com/mulecode/terraform.git//module/sqs"
  name = "my-sqs"
  visibility_timeout_seconds = 30
}

module "lambda_function_sample_trigger" {
  source = "github.com/mulecode/terraform.git//module/lambda_trigger"
  name = var.function_name
  description = "my lambda sample"
  handler = "uk.co.mulecode.lambda.ApplicationRequestHandler"
  runtime = "java11"
  iam_policy = local.policy
  file_path = local.artifact_path
  vpc_id = data.terraform_remote_state.context_vpc.outputs.vpc_id
  vpc_subnets = data.terraform_remote_state.context_vpc.outputs.public_subnets
  event_source_arn = module.my_sqs.sqs_arn
  timeout_seconds = 30
  environment_variables = {
    "profile" : "happy environment variable"
  }
}

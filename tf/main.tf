provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    encrypt = true
  }
}

locals {
  artifact_path = "../build/distributions/aws-lambda-java-template.zip"
  policy = <<JSON
{
    "Version": "2012-10-17",
    "Statement": [
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

// Lambda function with no trigger
//module "lambda_function_sample" {
//  source = "github.com/mulecode/terraform.git//module/lambda"
//  name = var.function_name
//  description = "my lambda sample"
//  handler = "uk.co.mulecode.lambda.ApplicationRequestHandler"
//  runtime = "java11"
//  file_path = local.artifact_path
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
//  file_path = local.artifact_path
//  schedule_expression = "cron(0/1 * ? * * *)"
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
  file_path = local.artifact_path
  event_source_arn = module.my_sqs.sqs_arn
  iam_policy = local.policy
  timeout_seconds = 30
  environment_variables = {
    "profile" : "happy environment variable"
  }
}

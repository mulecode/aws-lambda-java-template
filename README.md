# aws-lambda-java-template

Sample template of java lambda with gradle (KTS)

Includes:
- Secret Manager Service

### Setup

**Replace default `aws-lambda-java-template` to your project name.**

settings.gradle.kts
```kotlin
rootProject.name = "aws-lambda-java-template"
```

./tf/backend_config/dev.tfvars
```hcl-terraform
key = "aws-lambda-java-template/main.tfstate"
```

**Replace terraform S3 state bucket account Ids**

./tf/backend_config/dev.tfvars
```hcl-terraform
bucket = "terraform-<ACCOUNT_ID>"
```

./tf/env_vars/dev.tfvars
```hcl-terraform
state_bucket = "terraform-<ACCOUNT_ID>"
# Containerized and Serverless App

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

This repository composed of two main folder which are mapping each tasks such as containerizad-app and serverless-app.

## Tech

This repositoryis using different technology work properly:

- ✨Terraform
- ✨Docker
- ✨AWS
- ✨Bash  Scripting
- ✨Python
 
## Installation

For installition part CI/CD image is using correct image for environment. Images are alpine,terraform,hadolint,docker and awscli. To run pipeline correctly please define environment variables.

For production environments variables...

```sh
AWS_ACCESS_KEY_ID
AWS_ACCOUNT_ID
AWS_DEFAULT_REGION
AWS_SECRET_ACCESS_KEY
```

## CI/CD
These project includes 6 stages which are described below:
  - lint : Docker file check and lint by using Hadolint
  - publish : Publish docker image of containerzed project GITLAB registry and AWS ECR
  - terraform-validate: Validate terraform code.
  - terraform-plan: Init and plan terraform code
  - terraform-apply: Apply terraform code
  - terraform-destroy: Destroy resources in AWS.



## TEST
For serverless app , it offers local test environment. Below described steps show how to test serverless app locally. Aws cli, terraform and docker should be installed in local environment. After test script is compeleted. You can check test_output folder.
  
- ✨Terraform = v1.0.0
- ✨Docker   = 19.03.13
- ✨AWS CLI =   aws-cli/2.0.54 

Before run script AWS_SECRET_ACCESS_KEY, AWS_ACCESS_KEY_ID and AWS_REGION should be defined.
```sh
export AWS_SECRET_ACCESS_KEY="test"
export AWS_ACCESS_KEY_ID="test"
export AWS_DEFAULT_REGION= "us-east-1"
```
Alternatively, AWS_SECRET_ACCESS_KEY="test", AWS_ACCESS_KEY_ID="test" and AWS_DEFAULT_REGION= "us-east-1" should be defined with these values inside below comment.

```sh
aws configure
```

```sh
git clone git@gitlab.com:ardasendur/assignment.git
cd /serverless-app/terraform/aws/test
bash test.sh <PATH_OF_CSV_FILE>
cd test_output
```

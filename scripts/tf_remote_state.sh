#!/usr/bin/env bash
#
# Variables
AWS_PROFILE=${AWS_PROFILE:-default}
ENV=${ENV:-root}
RESOURCE=${1:-$RESOURCE}

AWS_REGION=$(${SCRIPTS}/read_cfg.sh $HOME/.aws/config "profile ${AWS_PROFILE}" region)
BUCKET_NAME=tf-remote-state-${ENV}
KMS_KEY_ALIAS=alias/tf-remote-state-${ENV}
DB_TABLE=terraform-remote-state-locking-${ENV}


# Create remote state S3 bucket
if aws s3 ls | grep $BUCKET_NAME > /dev/null 1>&2; then
  echo "Terraform Remote state bucket $BUCKET_NAME already exists. Skipping..." > /dev/null 1>&2
else
  aws s3api create-bucket --bucket $BUCKET_NAME
fi

# Create kms key
if aws kms list-aliases --output text | grep $KMS_KEY_ALIAS > /dev/null 1>&2; then
  echo "KMS key $KMS_KEY_ALIAS already exists. Skipping..." > /dev/null 1>&2
  AWS_KMS_KEY_ID=$(aws kms describe-key --key-id $KMS_KEY_ALIAS | jq --raw-output '.KeyMetadata.KeyId')
else
  AWS_KMS_KEY_ID=$(aws kms create-key \
      --description "KMS key used to encrypt and decrypt ${ENV} remote state file" \
      --key-usage ENCRYPT_DECRYPT \
      | jq --raw-output '.KeyMetadata.KeyId')
  # Create key alias
  aws kms create-alias --alias-name $KMS_KEY_ALIAS --target-key-id $AWS_KMS_KEY_ID
fi

# Create remote state dynamodb table
if aws dynamodb list-tables --output text | grep $DB_TABLE > /dev/null 1>&2; then
  echo "Remote state dynamodb table $DB_TABLE already exists. Skipping..." > /dev/null 1>&2
else
  aws dynamodb create-table \
      --table-name $DB_TABLE \
      --attribute-definitions AttributeName=LockID,AttributeType=S \
      --key-schema AttributeName=LockID,KeyType=HASH \
      --provisioned-throughput ReadCapacityUnits=10,WriteCapacityUnits=10
      
fi


  cat > terraform.tf <<BACKEND

#-----------------------------------#
# Terraform Remote State - Backend  #
#-----------------------------------#
terraform {
  required_version = ">= 0.12.6"
  backend "s3" {
    region         = "${AWS_REGION}"
    encrypt        = true
    bucket         = "${BUCKET_NAME}"
    key            = "${ENV}/${RESOURCE}/terraform.tfstate"
    kms_key_id     = "${AWS_KMS_KEY_ID}"
    profile        = "${AWS_PROFILE}"
    dynamodb_table = "${DB_TABLE}"
  }
}

BACKEND

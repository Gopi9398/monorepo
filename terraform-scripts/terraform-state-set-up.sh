####Run this script Firts before running any terraform commands to set up the S3 bucket and DynamoDB table for Terraform state management and locking.


#!/bin/bash

set -e

BUCKET_NAME="8byte-terraform-state-bucket"
REGION="ap-south-1"
TABLE_NAME="terraform-lock-table"

echo "Checking S3 bucket..."

if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "S3 bucket already exists"
else
  echo "Creating S3 bucket..."
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$REGION" \
    --create-bucket-configuration LocationConstraint=$REGION
fi

echo "Enabling versioning on S3 bucket..."
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled

echo "Checking DynamoDB table..."

if aws dynamodb describe-table --table-name "$TABLE_NAME" --region "$REGION" 2>/dev/null; then
  echo "DynamoDB table already exists"
else
  echo "Creating DynamoDB table..."
  aws dynamodb create-table \
    --table-name "$TABLE_NAME" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "$REGION"
fi

echo "Setup complete ✅"
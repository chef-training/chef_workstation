#!/bin/bash
rm -r ./vendor/cookbooks
berks install --path ./vendor/cookbooks
packer build \
  -var "account_id=$AWS_ACCOUNT_ID" \
  -var "aws_access_key_id=$AWS_ACCESS_KEY_ID" \
  -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY" \
  -var "x509_cert_path=$AWS_X509_CERT_PATH" \
  -var "x509_key_path=$AWS_X509_KEY_PATH" \
  -var "s3_bucket=$AWS_S3_BUCKET" \
  packer.json

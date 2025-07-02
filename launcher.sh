#!/bin/bash

set -e

cd terraform
echo "Running terraform apply..."
terraform apply -auto-approve


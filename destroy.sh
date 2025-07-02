#!/bin/bash

set -e

cd terraform
echo "destroy instance..."
terraform destroy -auto-approve



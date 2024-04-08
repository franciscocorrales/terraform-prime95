#!/bin/bash

echo "Value of PRIME_TAR_PATH passed from Terraform: $PRIME_TAR_PATH"
echo "Value of MERSENNE_USERNAME passed from Terraform: $MERSENNE_USERNAME"

# Update and install dependencies
# sudo apt-get update && sudo apt-get install -y any_dependencies_Prime95_needs

# Download Prime95 (assuming a Linux version is available)
curl $PRIME_TAR_PATH

# Unpack
tar -xvzf prime95.tar.gz

# Execute Prime95 (adjust the path and execution options as needed)
./mprime -m

# TODO login to Prime95 with user $MERSENNE_USERNAME
# TODO settings and configs
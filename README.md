# Description

Exploring Azure with Terraform. This project provisions a low-cost environment for searching Mersenne prime numbers using Prime95.

## Setup

### Configuration and secrets

Create a file to store you secrets and configurations: terraform.tfvars. Override any variable from the variables.tf file.

### Sign in

```markdown
az login
```

### Run Terraform init

```markdown
terraform init
```

### Run Terraform apply

```markdown
terraform apply
```

Important Note: When finished testing, run the following command to tear down the infrastructure and avoid incurring further charges:

```markdown
terraform destroy
```

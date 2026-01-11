## Cloud-1

Cloud-1 is a 42 DevOps project focused on infrastructure-as-code and configuration management in a real cloud environment.  
The goal is to describe and deploy a complete architecture where i used **Terraform** for provisioning and **Ansible** for configuration, with reproducible automation.

***

## Objectives

- Define cloud resources (instances, networking, security, etc.) with **Terraform** instead of manual clicks in the provider’s console.
- Configure provisioned machines with **Ansible** (packages, services, app deployment) using inventories and playbooks tied to Terraform outputs.
- Automate lifecycle operations (install, launch, destroy) with simple shell scripts so the stack can be reliably recreated.

***

## Repository structure

Your current layout:

```txt
.
├── ansible/
│   ├── inventory/
│   ├── playbooks/
│   └── ansible.cfg
├── inception/
│
├── Makefile
├── keys/
│   └── ychibanimock.pem
├── terraform/
│   ├── data.tf
│   ├── inventory.tf
│   ├── inventory.tfpl
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── variables.tf
├── README.md
├── destroy.sh
├── install.sh
└── launcher.sh
```

- **terraform/**: Terraform configuration for cloud resources (provider, network, instances, outputs).
- **ansible/**: Ansible configuration and playbooks that consume Terraform outputs to configure the instances (inventory, roles, variables).

***

## Architecture

The following diagram shows the Terraform-managed architecture for Cloud-1, as captured in the screenshot:

<img width="930" height="722" alt="image" src="https://github.com/user-attachments/assets/8ee8aec7-c4be-4d4b-bf59-48b0c052cc2e" />

***

## Terraform (in `terraform/`)

Terraform is responsible for describing and creating all cloud resources.

Main files:

- `providers.tf`: Configures the cloud provider and required Terraform plugins.  
- `variables.tf`: Declares input variables (region, instance types, key names, etc.).  
- `main.tf`: Defines core resources (VPC, subnets, instances, security groups, etc.).  
- `data.tf`: Optional data sources (e.g. existing AMIs, key pairs).  
- `outputs.tf`: Exposes values (IPs, hostnames, SSH info) consumed by Ansible.
- `inventory.tf` + `inventory.tfpl`: Generate a dynamic Ansible inventory from Terraform outputs.

Typical workflow:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

After `terraform apply`, use the generated inventory and outputs when running Ansible.

***

## Ansible (in `ansible/`)

Ansible connects to the created instances and configures them.

Key elements:

- `ansible.cfg`: Local Ansible configuration (defaults, inventory path, SSH options).  
- `inventory/`: Static or generated inventory files using Terraform outputs.  
- `playbooks/`: Playbooks to install packages, configure services, deploy your application or stack.


***

## Automation scripts

At the repo root, scripts orchestrate Terraform and Ansible:

- `install.sh`: Prepare local dependencies (Terraform, Ansible, plugins, maybe Terraform init).  
- `launcher.sh`: High-level script that typically runs Terraform apply and then relevant Ansible playbooks in the correct order.
- `destroy.sh`: Tear down the entire infrastructure (Terraform destroy) and optionally clean generated files.

Example flow:

```bash
./install.sh      # one-time or when dependencies change
./launcher.sh     # provision infra + configure with Ansible
./destroy.sh      # destroy all cloud resources
```

***

## Makefile

The `Makefile` can wrap common commands for convenience:

- `make init` → Initialize Terraform and any prerequisites.  
- `make up`   → Apply Terraform and run Ansible to configure everything.  
- `make down` → Destroy infrastructure via Terraform and cleanup.  

Document the actual targets you implement so the evaluator knows what to run.

***

## Keys & security

- **keys/ychibanimock.pem**: SSH private key used to connect to the instances; this should be kept safe and not committed in a real project.  
- In the context of 42, document clearly how the evaluator should use the key (permissions, SSH command examples) to connect to the machines.  

***

## Prerequisites

List what is needed on the local machine:

- Terraform
- Ansible
- Access to a supported cloud provider (credentials set via environment variables or config files).  

Then show a minimal “quick start”:

```bash
./install.sh
./launcher.sh
./destroy.sh
```



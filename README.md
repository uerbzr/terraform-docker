# Terraform vs Docker!

This repo is dedicated to creating Terraform scripts to create containers in Docker Desktop

## Setup

- Ensure you have Terraform insalled locally
- Ensure you have Docker installed locally

## Usage

Each directory on a given tech, contains a `main.tf` with a script to pull down and spin up a container.

To execute the Terraform:

- `terraform init`
- `terraform plan`
- `terraform apply -auto-approve`
- `terraform destroy`

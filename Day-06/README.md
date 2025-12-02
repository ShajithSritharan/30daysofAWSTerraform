# #30DaysOfAWSTerraform

## Day 06 — Building a Structured Terraform Project

Today is all about turning a single Terraform file into a well-organized project that scales. By splitting configuration into purposeful files, you get clarity, easier collaboration, and safer delivery.

### Learning objectives
- Understand why Terraform projects should be split into logical files.
- See how providers, backends, variables, locals, and resources fit together.
- Learn how to tag and output resources for traceability.
- Know where to keep environment-specific values out of Git.

### Baseline layout
The repository uses a simple, readable layout that keeps intent clear:

```bash
main.tf -------------------------> Resource definitions (S3, VPC, EC2)
variables.tf --------------------> Input variables (bucket name, environment)
locals.tf -----------------------> Shared values such as common tags
outputs.tf ----------------------> Values surfaced after apply
providers.tf --------------------> Provider pinning and region selection
backend.tf ----------------------> Remote state configuration (S3 with locking)
terraform.tfvars ----------------> Actual environment values (never commit)
terraform.tfvars.example --------> Safe template to show required inputs
.gitignore ----------------------> Keeps state/artifacts out of Git
README.md -----------------------> This guide
```

For larger footprints, introduce environment folders (for example, `dev/`, `prod/`) and extract reusable modules for networking, compute, and shared services.

### Terraform manifest notes
- `providers.tf`: Pins the AWS provider to `~> 6.0`, sets Terraform `>= 1.0.0`, and selects `ca-central-1` so resources land in a consistent region.
- `backend.tf`: Stores state remotely in `my-terraform-state-bucket-50000234` at `dev/terraform.tfstate`, with encryption and locking enabled to prevent drift.
- `locals.tf`: Defines `common_tags` (project and environment) that are reused across all resources for consistent metadata.
- `variables.tf`: Accepts `bucket_name` and `environment`, defaulting to a dev-friendly bucket name and `dev` environment.
- `main.tf`: Provisions an S3 bucket, a `/16` VPC, and an EC2 instance using the latest Amazon Linux 2023 SSM AMI. All are tagged with the shared `common_tags` so they’re easy to find.
- `outputs.tf`: Exposes the bucket name, VPC ID, and EC2 instance ID after `terraform apply`, making it simple to feed these into downstream steps.

### Why this structure helps
- Clear ownership: Each file has a single job, reducing merge conflicts.
- Safety: Remote state with locking protects against accidental overwrites.
- Reuse: Locals and variables keep resource names consistent across environments.
- Operability: Outputs surface the essentials for handoffs and automation.

### Summary
Splitting Terraform into focused files gives you repeatability, safer collaboration, and a natural path to grow into per-environment folders and modules as the estate expands.

### Watch: AWS Terraform Project Structure Best Practices
Video: https://www.youtube.com/watch?v=QMsJholPkDY

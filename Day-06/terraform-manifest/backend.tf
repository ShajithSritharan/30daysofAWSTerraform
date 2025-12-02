terraform {
    backend "s3" {
    bucket = "my-terraform-state-bucket-50000234"
    key    = "dev/terraform.tfstate" # path within the bucket
    region = "ca-central-1"
    encrypt = true # to enable server-side encryption for the state
    use_lockfile = true # to enable state locking
  }
}
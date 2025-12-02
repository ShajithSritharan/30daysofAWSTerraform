#Define locals
locals {
    common_tags = {
        Project     = "terraformdemo"
        Environment = var.environment
    }
}

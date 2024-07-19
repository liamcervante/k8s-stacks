
variable "google-project" {
  type    = string
  default = "hc-795dc63e1b494248b4ac514f7e9"
}

variable "google-region" {
  type    = string
  default = "europe-west3"
}

provider "google" {
  region  = var.google-region
  project = var.google-project
}

resource "google_iam_workload_identity_pool" "tfc" {
  workload_identity_pool_id = "terraform-cloud"
}

resource "google_iam_workload_identity_pool_provider" "tfc" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.tfc.workload_identity_pool_id
  workload_identity_pool_provider_id = "terraform-cloud-id"
  attribute_mapping = {
    "google.subject"                            = "assertion.sub",
    "attribute.aud"                             = "type(assertion.aud) == list ? assertion.aud[0] : assertion.aud",
    "attribute.terraform_operation"             = "assertion.terraform_operation",
    "attribute.terraform_stack_deployment_name" = "assertion.terraform_stack_deployment_name",
    "attribute.terraform_stack_id"              = "assertion.terraform_stack_id",
    "attribute.terraform_stack_name"            = "assertion.terraform_stack_name",
    "attribute.terraform_project_id"            = "assertion.terraform_project_id",
    "attribute.terraform_project_name"          = "assertion.terraform_project_name",
    "attribute.terraform_organization_id"       = "assertion.terraform_organization_id",
    "attribute.terraform_organization_name"     = "assertion.terraform_organization_name",
    "attribute.terraform_plan_id"               = "assertion.terraform_plan_id"
  }
  oidc {
    issuer_uri = "https://app.terraform.io"
  }

  // only my organisation can access, and only from the stacks project
  attribute_condition = "assertion.sub.startsWith(\"organization:org-bG8tiTdMQAnQd7do:project:prj-YZTms1HGmqYxN9oH\")"
}

resource "google_service_account" "tfc" {
  account_id   = "tfc-service-account"
  display_name = "Terraform Cloud Service Account"
}

resource "google_service_account_iam_member" "tfc" {
  service_account_id = google_service_account.tfc.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.tfc.name}/*"
}

resource "google_project_iam_member" "tfc_project_member" {
  project = var.google-project
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.tfc.email}"
}

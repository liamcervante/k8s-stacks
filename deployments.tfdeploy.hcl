identity_token "gcp" {
    audience = ["//iam.googleapis.com/projects/966135268298/locations/global/workloadIdentityPools/terraform-cloud/providers/terraform-cloud-id"]
}

# identity_token "kube" {
#     audience = ["gke-demo"]
# }

deployment "demo" {
    inputs = {
        cluster_name        = "demo"
        kubernetes_version  = "1.29"
        identity_token_gcp = identity_token.gcp.jwt_filename
        # identity_token_kube = identity_token.kube.jwt_filename
        gcp_audience        = "//iam.googleapis.com/projects/966135268298/locations/global/workloadIdentityPools/terraform-cloud/providers/terraform-cloud-id"
        gcp_project         = "hc-795dc63e1b494248b4ac514f7e9"
        gcp_region          = "europe-west3"
        gcp_service_account_email = "tfc-service-account@hc-795dc63e1b494248b4ac514f7e9.iam.gserviceaccount.com"
    }
}
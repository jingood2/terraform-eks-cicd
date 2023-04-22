################################################################################
# Kubernetes Addons
################################################################################
module "kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.29.0"

  eks_cluster_id        = module.eks_blueprints.eks_cluster_id
  eks_cluster_endpoint  = module.eks_blueprints.eks_cluster_endpoint
  eks_oidc_provider     = module.eks_blueprints.oidc_provider
  eks_cluster_version   = module.eks_blueprints.eks_cluster_version

  # Wait on the node group(s) before provisioning addons
  #data_plane_wait_arn = join(",", [for group in module.eks_blueprints.managed_node_groups : group.node_group_arn])

  #-----------------AWS Managed EKS Add-ons----------------------
  enable_amazon_eks_aws_ebs_csi_driver = false


  # Self-Managed Add-ons
  enable_argocd         = true
  # Indicates that ArgoCD is responsible for managing/deploying Add-ons
  argocd_manage_add_ons = true

  argocd_applications = var.cleanup_argocd_applications ? {} : {
    addons    = {
      path               = "chart"
      repo_url           = "https://github.com/aws-samples/eks-blueprints-add-ons.git"
      add_on_application = true
    }
    #workloads = local.workload_application #We comment it for now
  }


  # This example shows how to set default ArgoCD Admin Password using SecretsManager with Helm Chart set_sensitive values.
  argocd_helm_config = {
    set_sensitive = [
      {
        name  = "configs.secret.argocdServerAdminPassword"
        value = bcrypt_hash.argo.id
      }
    ],
    timeout          = "3600" # changed from 1200
    #set = [
    #  {
    #    name  = "server.service.type"
    #    value = "LoadBalancer"
    #  }
    #]
  }

  /* aws_load_balancer_controller_helm_config = {
    name                       = "aws-load-balancer-controller"
    chart                      = "aws-load-balancer-controller"
    repository                 = "https://aws.github.io/eks-charts"
    version                    = "1.3.1"
    namespace                  = "kube-system"
    values = [templatefile("${path.module}/values.yaml", {
      replicaCount = 1
    })]
  } */
  
  #---------------------------------------------------------------
  # Kubernetes ADD-ONS - You can add additional addons here
  # https://aws-ia.github.io/terraform-aws-eks-blueprints/add-ons/
  #---------------------------------------------------------------
  enable_aws_load_balancer_controller  = false
  enable_aws_for_fluentbit             = false
  enable_metrics_server                = true
  enable_aws_efs_csi_driver            = var.enable_efs
  enable_airflow                       = false
  enable_aws_fsx_csi_driver            = false
  enable_aws_cloudwatch_metrics        = false
  enable_aws_node_termination_handler  = false
  enable_cert_manager                  = false
  enable_cert_manager_csi_driver       = false
  enable_cluster_autoscaler            = false
  enable_datadog_operator              = false
  enable_external_dns                  = false
  enable_fargate_fluentbit             = false
  enable_grafana                       = false
  enable_ingress_nginx                 = false
  enable_karpenter                     = false
  enable_keda                          = false
  enable_kubernetes_dashboard          = false
  enable_prometheus                    = false
  enable_thanos                        = false
  enable_vpa                           = false
  enable_velero                        = false
  enable_amazon_eks_adot               = false
  enable_emr_on_eks                    = false
  enable_cilium                        = false
  enable_kubecost                      = false
  enable_calico                        = false
  
}

#---------------------------------------------------------------
# ArgoCD Admin Password credentials with Secrets Manager
# Login to AWS Secrets manager with the same role as Terraform to extract the ArgoCD admin password with the secret name as "argocd"
#---------------------------------------------------------------
resource "random_password" "argocd" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Argo requires the password to be bcrypt, we use custom provider of bcrypt,
# as the default bcrypt function generates diff for each terraform plan
resource "bcrypt_hash" "argo" {
  cleartext = random_password.argocd.result
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
#resource "aws_secretsmanager_secret" "argocd" {
#  name                    = "${local.prefix_name}-argocd"
#  recovery_window_in_days = 0 # Set to zero for this example to force delete during Terraform destroy
#}

#resource "aws_secretsmanager_secret_version" "argocd" {
#  secret_id     = aws_secretsmanager_secret.argocd.id
#  secret_string = random_password.argocd.result
#}
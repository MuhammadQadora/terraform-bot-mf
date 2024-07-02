### external DNS HELM CHART
# resource "helm_release" "external-dns-chart" {
#   name       = "externaldns-release"
#   namespace = "kube-system"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "external-dns"
#   version    = "7.5.5"

#   values = [file("${path.module}/externalDNS-vals.yaml")]


#   set {
#     name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = var.external_dns_role_arn
#   }

#   set {
#     name = "policy"
#     value = "sync"
#   }

#   set {
#     name = "txtOwnerId"
#     value = "external-dns"
#   }


#   set {
#     name = "aws.region"
#     value = var.region
#   }
#     depends_on = [ helm_release.metrics-server ]
# }

# #### INGRESS CONTRROLLER
# resource "helm_release" "nginx-ingress" {
#   name = "ingress-nginx"
#   namespace = "kube-system"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart = "ingress-nginx"
#   version = "4.10.1"
  
#   values = [file("${path.module}/nginx-ingress-values.yaml")]
# }

# resource "helm_release" "ingress_controller" {
#   name = "aws-ingress-controller"
#   repository = "https://aws.github.io/eks-charts"
#   namespace = "kube-system"
#   chart = "aws-load-balancer-controller"
#   version = "1.8.1"

#   set {
#     name = "serviceAccount.name"
#     value = "ingress-sa"
#   }

#   set {
#     name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = var.aws_ingress_controller_role_arn
#   }

#   set {
#     name = "clusterName"
#     value = var.cluster_name
#   }
#   set {
#     name = "vpcId"
#     value = var.vpc_id
#   }
#   set {
#     name = "region"
#     value = var.region
#   }
#   depends_on = [ helm_release.metrics-server ]
# }



########################
## HELM CHART FOR PROMETHEUS OPERATOR AND GRAFANA
################################################### FOR THIS CHART YOU NEED TO CHANGE THE PASSOWRD FOR GRAFANA !!!!!!!
# resource "helm_release" "kube-prometheus-stack" {
#   name = "prometheus"
#   namespace = "monitoring"
#   create_namespace = "true"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart = "kube-prometheus-stack"
#   depends_on = [ helm_release.metrics-server ]
# }


###############################################################
### HELM CHART FOR CERT MANAGER 

# resource "helm_release" "cert-manager" {
#   name = "cert-manager"
#   namespace = "cert-manager"
#   create_namespace = "true"
#   repository = "https://charts.jetstack.io"
#   chart = "cert-manager"
#   version = "1.15.0"

#   set {
#     name = "crds.enabled"
#     value = "true"
#   }
  
#   set {
#     name = "prometheus.servicemonitor.enabled"
#     value = "true"
#   }
#   depends_on = [ helm_release.metrics-server]
# }

##################################################################
## METRICS SERVER HELM CHART



# resource "helm_release" "metrics-server" {
#   name = "metrics-server"
#   repository = "https://kubernetes-sigs.github.io/metrics-server/"
#   namespace = "kube-system"
#   chart = "metrics-server"
#   version = "3.12.1"
# }


######################################################################
### ARGOCD HELMCHART
resource "helm_release" "argocd" {
  name = "argocd"
  namespace = "argocd"
  create_namespace = "true"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  version = "7.3.2"
  values = [file("${path.module}/vals.yaml")]
}

#################################################################
### Cluster autoscaler helm chart

# resource "helm_release" "cluster_autoscaler" {
#   name = "cluster-autoscaler"
#   namespace = "kube-system"
#   repository = "https://kubernetes.github.io/autoscaler"
#   chart = "cluster-autoscaler"
#   version = "9.37.0"

#   set {
#     name = "autoDiscovery.clusterName"
#     value = var.cluster_name
#   }

#   set {
#     name = "awsRegion"
#     value = var.region
#   }

#   set {
#     name = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = var.cluster_autoscaler_role_arn
#   }
  
#   set {
#     name = "rbac.serviceAccount.name"
#     value = "cluster-autoscaler"
#   }
# }


###################################################################
##### KARPENTER HELM CHART 

# data "aws_iam_role" "karpenter-role" {
#   name = "KarpenterController-${var.cluster_name}"
# }

resource "helm_release" "karpenter" {
  namespace        = "kube-system"
  name       = "karpenter"
  chart      = "oci://public.ecr.aws/karpenter/karpenter"
  version    = "0.37.0"
  wait = true

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.karpenter-role
  }
  set {
    name = "serviceAccount.name"
    value = "karpenter"
  }

  set {
    name  = "settings.clusterName"
    value = var.cluster_name
  }
  
  set {
    name = "controller.resources.requests.cpu"
    value = "1"
  }
  set {
    name = "controller.resources.requests.memory"
    value = "1Gi"
  }

  set {
    name = "controller.resources.limits.cpu"
    value = "1"
  }

  set {
    name = "controller.resources.limits.memory"
    value = "1Gi"
  }
}

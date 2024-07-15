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



###################################################################
##### KARPENTER HELM CHART 

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

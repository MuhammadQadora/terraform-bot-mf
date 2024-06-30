output "endpoint" {
  value = aws_eks_cluster.mf-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.mf-cluster.certificate_authority[0].data
  sensitive = true
}

output "issuer_url" {
  value = aws_eks_cluster.mf-cluster.identity.0.oidc.0.issuer
  sensitive = true
}

output "cluster_name" {
  value = aws_eks_cluster.mf-cluster.name
}

output "external_dns_role_arn" {
  value = aws_iam_role.external-dns-pod-role.arn
}

output "aws_ingress_controller_role_arn" {
  value = aws_iam_role.ingress_controller_role.arn
}


output "cluster-autoscaler-role-arn" {
  value = aws_iam_role.cluster-autoscaler-role.arn
}

# output "aws_karpenter_role_arn" {
#   value = aws_iam_role.karpenter-role.arn
# }

# output "karpenter_instance_profile" {
#   value = aws_cloudformation_stack.karpenter-stack.ar
# }
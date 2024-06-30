resource "aws_eks_addon" "cni" {
  cluster_name = aws_eks_cluster.mf-cluster.name
  addon_name   = "vpc-cni"
  service_account_role_arn = aws_iam_role.cni-role.arn
  addon_version               = "v1.18.1-eksbuild.3" #e.g., previous version v1.9.3-eksbuild.3 and the new version is v1.10.1-eksbuild.1
  resolve_conflicts_on_update = "PRESERVE"
  depends_on = [ aws_iam_role.cni-role ]
}

resource "aws_eks_addon" "eks-pod-identity-agent" {
  cluster_name = aws_eks_cluster.mf-cluster.name
  addon_name   = "eks-pod-identity-agent"
  service_account_role_arn = aws_iam_role.worker-node-role.arn
  depends_on = [ aws_iam_role.worker-node-role ]
}

resource "aws_eks_addon" "aws-ebs-csi-driver" {
  cluster_name = aws_eks_cluster.mf-cluster.name
  addon_name   = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs-driver-role.arn
  depends_on = [ aws_iam_role.ebs-driver-role ]
}

resource "aws_eks_addon" "cordns" {
  cluster_name = aws_eks_cluster.mf-cluster.name
  addon_name   = "coredns"
  addon_version               = "v1.11.1-eksbuild.9" #e.g., previous version v1.9.3-eksbuild.3 and the new version is v1.10.1-eksbuild.1
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name = aws_eks_cluster.mf-cluster.name
  addon_name   = "kube-proxy"
  addon_version               = "v1.29.3-eksbuild.2" #e.g., previous version v1.9.3-eksbuild.3 and the new version is v1.10.1-eksbuild.1
  resolve_conflicts_on_update = "PRESERVE"
}
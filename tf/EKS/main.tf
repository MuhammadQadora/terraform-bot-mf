resource "aws_eks_cluster" "mf-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks-cluster-role.arn
  vpc_config {
    subnet_ids = [var.public_subnet_ids[0],var.public_subnet_ids[1],var.public_subnet_ids[2],var.private_subnet_ids[0],var.private_subnet_ids[1]]
    endpoint_private_access = false
    endpoint_public_access  = true
    public_access_cidrs = ["0.0.0.0/0"]
  }

  access_config {
    authentication_mode = var.authentication_mode
  }
  tags = {
    "Name" = "mf-cluster"
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy
  ]
}

data "tls_certificate" "mf-cluster-cert" {
  url = aws_eks_cluster.mf-cluster.identity[0].oidc[0].issuer
  depends_on = [ aws_eks_cluster.mf-cluster ]
}

resource "aws_iam_openid_connect_provider" "mf-cluster-provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.mf-cluster-cert.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.mf-cluster.identity[0].oidc[0].issuer
  depends_on = [ aws_eks_cluster.mf-cluster ]
}

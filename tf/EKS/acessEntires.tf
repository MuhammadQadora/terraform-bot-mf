#################################################################
##### Admin policy for the user firas.narani

data "aws_iam_user" "firas" {
  user_name = var.user_name_firas
}

resource "aws_eks_access_entry" "firas" {
  cluster_name      = aws_eks_cluster.mf-cluster.name
  principal_arn     = data.aws_iam_user.firas.arn
  type              = "STANDARD"
  depends_on = [ aws_eks_cluster.mf-cluster ]
}


resource "aws_eks_access_policy_association" "firas" {
  cluster_name  = aws_eks_cluster.mf-cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = data.aws_iam_user.firas.arn

  access_scope {
    type       = "cluster"
  }
}

##########################################################################
## admin policy for the user memomq

data "aws_iam_user" "admin" {
  user_name = var.user_name
}

resource "aws_eks_access_entry" "memomq" {
  cluster_name      = aws_eks_cluster.mf-cluster.name
  principal_arn     = data.aws_iam_user.admin.arn
  type              = "STANDARD"
  depends_on = [ aws_eks_cluster.mf-cluster ]
}


resource "aws_eks_access_policy_association" "memomq" {
  cluster_name  = aws_eks_cluster.mf-cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = data.aws_iam_user.admin.arn

  access_scope {
    type       = "cluster"
  }
}



################################################################
### adminpolicy for the jenkins ec2 instance
resource "aws_eks_access_entry" "jenkins" {
  cluster_name      = aws_eks_cluster.mf-cluster.name
  principal_arn     = "arn:aws:iam::933060838752:role/jenkins-role"
  type              = "STANDARD"
  depends_on = [ aws_eks_cluster.mf-cluster ]
}


resource "aws_eks_access_policy_association" "jenkins" {
  cluster_name  = aws_eks_cluster.mf-cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::933060838752:role/jenkins-role"

  access_scope {
    type       = "cluster"
  }
}


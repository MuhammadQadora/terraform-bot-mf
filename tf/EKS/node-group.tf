# resource "aws_eks_node_group" "main" {
#   cluster_name    = aws_eks_cluster.mf-cluster.name
#   node_group_name = "main"
#   node_role_arn   = aws_iam_role.worker-node-role.arn
#   subnet_ids      = [var.private_subnet_ids[0],var.private_subnet_ids[1]]

#   tags = {
#     "Name" = "mf-cluster-main-node-group"
#   }
  
#   scaling_config {
#     desired_size = 2
#     max_size     = 10
#     min_size     = 1
#   }

#   lifecycle {
#     ignore_changes = [scaling_config[0].desired_size]
#   }

#   update_config {
#     max_unavailable = 1
#   }
#   disk_size = 30
#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces
#   depends_on = [ aws_iam_role_policy_attachment.workerNode-role, aws_iam_role_policy_attachment.cni-worker-role-attachment,
#   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistry-node-role ]
# }
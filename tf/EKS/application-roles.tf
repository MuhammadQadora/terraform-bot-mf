####################################################################
#### TELEGRAMBOT ROLE
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "bot-role" {
  name               = "mf-bot-role"
  assume_role_policy = data.aws_iam_policy_document.pod_assume_role.json
}


resource "aws_iam_policy" "bot-policy" {
  name = "mf-bot-policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "dynamo",
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:Query",
                "dynamodb:Scan"
            ],
            "Resource": [
                "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.predictions_table_name_dev}",
                "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.gpt_table_name_dev}",
                "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.predictions_table_name_prod}",
                "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.gpt_table_name_prod}"
            ]
        },
        {
            "Sid": "s3",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::mqbucket1/*"
            ]
        },
        {
            "Sid": "secretsm",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": [
                "arn:aws:secretsmanager:us-east-1:${data.aws_caller_identity.current.account_id}:secret:polybotSecretsMQ-eC5Tdq"
            ]
        },
         {
            "Sid": "sns",
            "Effect": "Allow",
            "Action": [
                "sns:GetSubscriptionAttributes",
                "sns:ConfirmSubscription",
                "sns:Subscribe",
                "sns:Unsubscribe"
            ],
            "Resource": [
                "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:${var.sns_name_dev}",
                "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:${var.sns_name_prod}"
            ]
        },
        {
            "Sid": "sqs",
            "Effect": "Allow",
            "Action": [
                "sqs:GetQueueUrl",
                "sqs:SendMessage"
            ],
            "Resource": [
                "arn:aws:sqs:${var.region}:${data.aws_caller_identity.current.account_id}:${var.sqs_name_dev}",
                "arn:aws:sqs:${var.region}:${data.aws_caller_identity.current.account_id}:${var.sqs_name_prod}"
            ]
        }
    ]
})
}


resource "aws_iam_role_policy_attachment" "bot-role-attachment" {
  policy_arn = aws_iam_policy.bot-policy.arn
  role       = aws_iam_role.bot-role.name
  depends_on = [ aws_iam_role.bot-role ]
}

resource "aws_eks_pod_identity_association" "cluster-association-dev" {
  cluster_name    = aws_eks_cluster.mf-cluster.name
  namespace       = "dev"
  service_account = "bot-sa"
  role_arn        = aws_iam_role.bot-role.arn
  depends_on = [ aws_iam_role.bot-role,aws_eks_addon.eks-pod-identity-agent]
}

resource "aws_eks_pod_identity_association" "cluster-association-prod" {
  cluster_name    = aws_eks_cluster.mf-cluster.name
  namespace       = "prod"
  service_account = "bot-sa"
  role_arn        = aws_iam_role.bot-role.arn
  depends_on = [ aws_iam_role.bot-role,aws_eks_addon.eks-pod-identity-agent]
}


############################################################################
##### WORKER YOLOV5 role

resource "aws_iam_role" "worker-yolov5-role" {
  name               = "worker-yolov-role"
  assume_role_policy = data.aws_iam_policy_document.pod_assume_role.json
}

resource "aws_iam_policy" "worker-yolov5-policy" {
  name = "worker-yolov5-policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "dynamo",
            "Effect": "Allow",
            "Action": [
                "dynamodb:DescribeTable",
                "dynamodb:DescribeTimeToLive",
                "dynamodb:PutItem"
            ],
            "Resource": [
                "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.predictions_table_name_dev}",
                "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.predictions_table_name_prod}"
            ]
        },
        {
            "Sid": "s3",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::mqbucket1/*"
            ]
        },
         {
            "Sid": "secretsm",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": [
                "arn:aws:secretsmanager:us-east-1:${data.aws_caller_identity.current.account_id}:secret:yolov5-secret-mf-yUf9yi"
            ]
        },
         {
            "Sid": "sns",
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": [
                "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:${var.sns_name_dev}",
                "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:${var.sns_name_prod}"
            ]
        },
        {
            "Sid": "sqs",
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:GetQueueUrl",
                "sqs:GetQueueAttributes",
                "sqs:DeleteMessage"
            ],
            "Resource": [
                "arn:aws:sqs:${var.region}:${data.aws_caller_identity.current.account_id}:${var.sqs_name_dev}",
                "arn:aws:sqs:${var.region}:${data.aws_caller_identity.current.account_id}:${var.sqs_name_prod}"
            ]
        }

    ]
})
}


resource "aws_iam_role_policy_attachment" "worker-yolov5-role-attachment" {
  policy_arn = aws_iam_policy.worker-yolov5-policy.arn
  role       = aws_iam_role.worker-yolov5-role.name
  depends_on = [ aws_iam_role.worker-yolov5-role]
}

resource "aws_eks_pod_identity_association" "worker-yolov5-cluster-association-dev" {
  cluster_name    = aws_eks_cluster.mf-cluster.name
  namespace       = "dev"
  service_account = "worker-sa"
  role_arn        = aws_iam_role.worker-yolov5-role.arn
  depends_on = [ aws_iam_role.worker-yolov5-role,aws_eks_addon.eks-pod-identity-agent]
}

resource "aws_eks_pod_identity_association" "worker-yolov5-cluster-association-prod" {
  cluster_name    = aws_eks_cluster.mf-cluster.name
  namespace       = "prod"
  service_account = "worker-sa"
  role_arn        = aws_iam_role.worker-yolov5-role.arn
  depends_on = [ aws_iam_role.worker-yolov5-role,aws_eks_addon.eks-pod-identity-agent]
}


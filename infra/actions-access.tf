# data "aws_iam_policy_document" "ecr_github_oidc_assume_role" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     principals {
#       type        = "Federated"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
#     }

#     condition {
#       test     = "StringLike"
#       variable = "token.actions.githubusercontent.com:sub"
#       values   = ["repo:<your_github_org_or_user>/<your_repo_name>:ref:refs/heads/*"]
#     }
#   }
# }

# resource "aws_iam_role" "github_actions_ecr" {
#   name               = "github-actions-ecr-role"
#   assume_role_policy = data.aws_iam_policy_document.ecr_github_oidc_assume_role.json

#   tags = {
#     Environment = var.env
#   }
# }

# resource "aws_iam_role_policy_attachment" "github_actions_ecr" {
#   role       = aws_iam_role.github_actions_ecr.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
# }

# output "github_actions_ecr_role_arn" {
#   value = aws_iam_role.github_actions_ecr.arn
#   description = "IAM Role ARN for GitHub Actions to push to ECR"
# }

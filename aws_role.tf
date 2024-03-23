data "aws_iam_policy_document" "auto_discover_cluster" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "autoscaling:DescribeAutoScalingGroups",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "instance_assume_role_document" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "server_instance_role" {
  name_prefix        = "${var.name}_server_"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_document.json
}

resource "aws_iam_role" "client_instance_role" {
  name_prefix        = "${var.name}_client_"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_document.json
}

resource "aws_iam_role" "bastion_instance_role" {
  name_prefix        = "${var.name}_bastion_"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_document.json
}

resource "aws_iam_role_policy_attachment" "server_policy_attachments" {
  for_each = toset(var.nomad_server.policy_arns)
  policy_arn = each.key
  role       = aws_iam_role.server_instance_role.name
}

resource "aws_iam_role_policy_attachment" "client_policy_attachments" {
  for_each = toset(var.nomad_client.policy_arns)
  policy_arn = each.key
  role       = aws_iam_role.client_instance_role.name
}

resource "aws_iam_role_policy_attachment" "bastion_policy_attachments" {
  for_each = toset(var.bastion.policy_arns)
  policy_arn = each.key
  role       = aws_iam_role.bastion_instance_role.name
}

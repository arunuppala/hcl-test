resource "aws_security_group" "additional" {
  name        = "${var.env}-eks-ng"
  description = "Additional security group for EKS node groups"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow all traffic within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.env}-eks-sg"
    Environment = var.env
  }
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  cluster_name                    = "${var.env}-cluster"
  cluster_version                 = "1.29"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Self Managed Node Group(s)
  self_managed_node_group_defaults = {
    instance_type                          = "t2.micro"
    update_launch_template_default_version = true
    iam_role_additional_policies = {
      SSM = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
  }


  self_managed_node_groups = {
    one = {
      name = "spot-1"

      public_ip    = true
      max_size     = 3
      desired_size = 2

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 10
          spot_allocation_strategy                 = "capacity-optimized"
        }
      }

      pre_bootstrap_user_data = <<-EOT
      echo "foo"
      export FOO=bar
      EOT

      bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"

      post_bootstrap_user_data = <<-EOT
      cd /tmp
      sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
      sudo systemctl enable amazon-ssm-agent
      sudo systemctl start amazon-ssm-agent
      EOT
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = 20
    instance_types         = ["t2.micro"]
    vpc_security_group_ids = [aws_security_group.additional.id]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t2.micro"]
      capacity_type  = "SPOT"
      labels = {
        Environment = "test"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }
      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      }
      tags = {
        ExtraTag = "example"
      }
    }
  }

  tags = {
    Terraform = "true"
  }
}
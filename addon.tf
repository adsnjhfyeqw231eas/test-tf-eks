variable "addons" {

  type = list(object({
    name    = string
    version = string
  }))

  default = [
    {
      name    = "kube-proxy"
      version = "v1.28.4-eksbuild.4"
    },
    {
      name    = "vpc-cni"
      version = "v1.16.0-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.10.1-eksbuild.7"
    },
    {
      name    = "eks-pod-identity-agent"
      version = "v1.1.0-eksbuild.1"
      //name    = "aws-ebs-csi-driver"
      //version = "v1.26.1-eksbuild.1"
    }
  ]

}

resource "aws_eks_addon" "addons" {
  for_each          = { for addon in var.addons : addon.name => addon }
  cluster_name      = aws_eks_cluster.demo.id
  addon_name        = each.value.name
  addon_version     = each.value.version
  resolve_conflicts_on_update = "OVERWRITE"
}



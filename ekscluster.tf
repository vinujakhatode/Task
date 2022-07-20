module "eks" {
  source    	        = "terraform-aws-modules/eks/aws"
  version 		= "~> 18.0"
  cluster_name          = local.cluster_name
  cluster_version 	= "1.22"
  subnet_ids            = module.vpc.private_subnets

  vpc_id 		= module.vpc.vpc_id
//  create_iam_role	=false

eks_managed_node_group_defaults   = {
   karpenter = {
	root_volume_type = "gp2"
	} 
}

eks_managed_node_groups  = {
 
  
   blue= {
      name                          = "worker-group-1"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo node1"
      additional_security_group_ids = [aws_security_group.node1.id]
      asg_desired_capacity          = 2
  //    create_iam_role       =false
  //  iam_role_arn          ="arn:aws:iam::553900043809:user/devops-candidate1"
  //    iam_role_name         ="devops-candidate1"
    }
   
   green= {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo node2"
      additional_security_group_ids = [aws_security_group.node2.id]
      asg_desired_capacity          = 1
  //    create_iam_role       =false
//      iam_role_arn          ="arn:aws:iam::553900043809:user/devops-candidate1"
//      iam_role_name         ="devops-candidate1"
}
 

 } 
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}


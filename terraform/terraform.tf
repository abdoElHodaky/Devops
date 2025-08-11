terraform {

   /*  cloud {
	organization = “abdoelhodaky”
	workspaces {
  	name = “kuberntestest”
	}
 } */
required_providers {

    aws = {

      source = "hashicorp/aws"

      version = "~> 5.10.0"

    }

    helm = {
          source  = "hashicorp/helm"
          version = "~> 3.0.0" 
        }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= ~> 2.37.0" 
   }

}

/*backend "s3" {
   bucket="terraform_remote_state"
   region="us-east-1"
   key="tf_remote_state"
   dynamodb_table="tf_remote_state_table_ec2"
  
 }*/


}



provider “aws” {

}


provider "kubernetes" {



 }

provider "helm" {
  
	  
  
  registries = [
    {
      url      = "oci://ghcr.io"
      username = "abdoElHodaky"
      password = var.GHCR_PAT
    }
  ]
}


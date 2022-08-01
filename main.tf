resource "aviatrix_vpc" "firenet_vpc1" {
  cloud_type           = 1
  account_name         = "flottAWS"
  region               = "us-west-2"
  name                 = "aws-firenetSofi"
  cidr                 = "10.15.16.0/23"
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = true
}

resource "aviatrix_vpc" "tgw_vpc2" {
  cloud_type           = 1
  account_name         = "flottAWS"
  region               = "us-west-2"
  name                 = "aws-common-Sofi"
  cidr                 = "10.17.18.0/24"
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
}


resource "aviatrix_aws_tgw" "test_aws_tgw1" {
  account_name                      = "flottAWS"
 
  aws_side_as_number                = "64513"
  manage_vpc_attachment             = false
  manage_transit_gateway_attachment = true
  region                            = "us-west-2"
  tgw_name                          = "test-AWS-TGW-Sofi"
  
  security_domains {
    security_domain_name = "Aviatrix_Edge_Domain"
   
  }

  security_domains {
    security_domain_name = "Default_Domain"
   
  }

  security_domains {
    security_domain_name = "Shared_Service_Domain"
    
    
  }

  security_domains {
    security_domain_name = "firewall-domain-Sofi"
    aviatrix_firewall    = true
  }
}

resource "aviatrix_transit_gateway" "test_transit_gateway_aws" {
  cloud_type               = 1
  account_name             = "flottAWS"
  gw_name                  = "firenetSofi"
  vpc_id                   = aviatrix_vpc.firenet_vpc1.vpc_id
  vpc_reg                  = "us-west-2"
  gw_size                  = "c5n.xlarge"
  subnet                   = aviatrix_vpc.firenet_vpc1.public_subnets[0].cidr
  ha_subnet                = aviatrix_vpc.firenet_vpc1.public_subnets[1].cidr
  ha_gw_size               = "c5n.xlarge"
  
  enable_hybrid_connection = true
  connected_transit        = true
  enable_firenet           = true
  enable_active_mesh       = true
}

resource "aviatrix_aws_tgw_vpc_attachment" "firenet_attachment1" {
  tgw_name             = aviatrix_aws_tgw.test_aws_tgw1.id
  region               = "us-west-2"
  security_domain_name = "firewall-domain-Sofi"
  vpc_account_name     = "flottAWS"
  vpc_id               = aviatrix_vpc.firenet_vpc1.vpc_id
}

resource "aviatrix_aws_tgw_vpc_attachment" "vpc_attachment1" {
  tgw_name             = aviatrix_aws_tgw.test_aws_tgw1.id
  region               = "us-west-2"
  security_domain_name = "Shared_Service_Domain"
  vpc_account_name     = "flottAWS"
  vpc_id               = aviatrix_vpc.tgw_vpc2.vpc_id
  #customized_routes    = "10.0.0.0/8"
}

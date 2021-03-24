module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"

  tags = local.tags
}


# module "nat" {
#   source           = "./modules/nat"
#   public_subnet_id = module.public_subnet_az1.subnet_id
#   vpc_id           = module.vpc.vpc_id

#   tags = local.tags
# }


module "public_subnet_az1" {
  source         = "./modules/subnet"
  cidr_block     = "10.0.1.0/24"
  vpc_id         = module.vpc.vpc_id
  route_table_id = module.vpc.gw_route_table_id
  public         = true

  tags = local.tags
}


# module "private_subnet_az1" {
#   source         = "./modules/subnet"
#   cidr_block     = "10.0.2.0/24"
#   vpc_id         = module.vpc.vpc_id
#   route_table_id = module.nat.nat_route_table_id

#   tags = local.tags
# }

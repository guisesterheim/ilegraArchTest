// Step 1: terraform init
// Step 2: terraform plan -var aws_region=us-east-1 -var aws_access_key=<access_key> -var aws_secret_key=<secret_key> -out tfout.log
// Step 3: terraform apply tfout.log
provider "aws" {
    region = var.aws_region
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

module "network" {
    imported_az1                = var.availability_zone_us_east_1
    imported_az2                = var.availability_zone_us_east_2

    source = "./modules/network"
}

module "autoscaling" {
    imported_sg_ssh                 = module.network.aws_security_group_ssh_id
    imported_sg_app                 = module.network.aws_security_group_app_id
    imported_sg_external            = module.network.aws_security_group_allow_external
    imported_subnetEastA_id         = module.network.aws_subnet_eastA_id
    imported_subnetEastB_id         = module.network.aws_subnet_eastB_id
    imported_publicSubnetEastA_id   = module.network.aws_subnet_public_eastA_id
    imported_publicSubnetEastB_id   = module.network.aws_subnet_public_eastB_id

    imported_az1                    = var.availability_zone_us_east_1
    imported_az2                    = var.availability_zone_us_east_2
    imported_vpc_id                 = module.network.aws_created_vpc_id

    source                      = "./modules/autoscaling"
}
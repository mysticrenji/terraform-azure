
variable "presentation" {
  description = "The name of the presentation - used for tagging Azure resources so I know what they belong to"
  default     = "armegeddon"
}

variable "ResourceGroupName" {
  description = "The Prefix used for all resources in this example"
  default     = "bastion-rg"
}

variable "location" {
  description = "The Azure Region in which the resources in this example should exist"
  default     = "westus"
}

variable "VNETName" {
  description = "Name of the VNET"
  default     = "aksworks-vnet"
}

variable "SqlServerName" {
  description = "The name of the Azure SQL Server to be created or to have the database on - needs to be unique, lowercase between 3 and 24 characters including the prefix"
  default     = "armegeddon"
}

variable "SQLServerAdminUser" {
  description = "The name of the Azure SQL Server Admin user for the Azure SQL Database"
  default     = "mysticrenji"
}
variable "SQLServerAdminPassword" {
  description = "The Azure SQL Database users password"
  default     = "Testing!988"
}
variable "SqlDatabaseName" {
  description = "The name of the Azure SQL database on - needs to be unique, lowercase between 3 and 24 characters including the prefix"
  default     = "terraform"
}


variable "Edition" {
  description = "The Edition of the Database - Basic, Standard, Premium, or DataWarehouse"
  default     = "Basic"
}

variable "ServiceObjective" {
  description = "The Service Tier S0, S1, S2, S3, P1, P2, P4, P6, P11 and ElasticPool"
  default     = "S0"
}
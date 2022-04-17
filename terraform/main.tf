terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rta-resource-group"
  location = "eastus"
}

resource "azurerm_role_assignment" "acrpull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].client_id
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true

}

resource "azurerm_container_registry" "acr" {
  location            = "eastus"
  name                = "rtaAcr"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "rta-demo-cluster"
  kubernetes_version  = 1.21
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "rta-demo-cluster"

  default_node_pool {
    name       = "system"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

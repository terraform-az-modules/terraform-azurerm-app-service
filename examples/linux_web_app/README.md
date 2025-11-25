<!-- BEGIN_TF_DOCS -->

# 🌐 Azure Linux Web App

This example demonstrates how to deploy an **Azure Linux Web App** using the module.   

---

## ✅ Requirements

| Name      | Version   |
|-----------|-----------|
| Terraform | >= 1.6.6  |
| Azurerm   | >= 3.116.0 |

---

## 🔌 Providers

No providers are explicitly defined in this example.

---

## 📦 Modules

| Name                | Source                                                                 | Version |
|---------------------|------------------------------------------------------------------------|---------|
| application-insights | git::https://github.com/terraform-az-modules/terraform-azure-application-insights.git | feat/update |
| linux-web-app        | ../..                                                                 | n/a     |
| log-analytics        | clouddrove/log-analytics/azure                                       | 2.0.0   |
| private-dns-zone     | terraform-az-modules/private-dns/azure                               | 1.0.0   |
| resource_group       | terraform-az-modules/resource-group/azure                            | 1.0.0   |
| subnet               | terraform-az-modules/subnet/azure                                    | 1.0.0   |
| subnet-ep            | terraform-az-modules/subnet/azure                                    | 1.0.0   |
| vnet                 | terraform-az-modules/vnet

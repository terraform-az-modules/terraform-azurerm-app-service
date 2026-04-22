## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acr\_id | Container registry id to give access to pull images | `string` | `null` | no |
| app\_insights\_api\_key\_enable | Enable creation of Application Insights API Key | `bool` | `false` | no |
| app\_insights\_connection\_string | Connection string of App Insights | `string` | `null` | no |
| app\_insights\_id | ID of the existing Application Insights resource to use | `string` | `null` | no |
| app\_insights\_instrumentation\_key | Instrumentation key of Application Insights | `string` | `null` | no |
| app\_service\_environment\_id | The ID of the App Service Environment to create this Service Plan in. Requires an Isolated SKU. Use one of I1, I2, I3 for azurerm\_app\_service\_environment, or I1v2, I2v2, I3v2 for azurerm\_app\_service\_environment\_v3 | `string` | `null` | no |
| app\_service\_logs | Configuration of the App Service and App Service Slot logs. Documentation [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#logs) | <pre>object({<br>    detailed_error_messages = optional(bool)<br>    failed_request_tracing  = optional(bool)<br>    application_logs = optional(object({<br>      file_system_level = string<br>      azure_blob_storage = optional(object({<br>        level             = string<br>        retention_in_days = number<br>        sas_url           = string<br>      }))<br>    }))<br>    http_logs = optional(object({<br>      azure_blob_storage = optional(object({<br>        retention_in_days = number<br>        sas_url           = string<br>      }))<br>      file_system = optional(object({<br>        retention_in_days = number<br>        retention_in_mb   = number<br>      }))<br>    }))<br>  })</pre> | `null` | no |
| app\_service\_vnet\_integration\_subnet\_id | Id of the subnet to associate with the app service | `string` | `null` | no |
| app\_settings | Application settings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings | `map(string)` | `{}` | no |
| application\_insights\_enabled | Enable Application Insights integration | `bool` | `true` | no |
| auth\_settings | Authentication settings. Issuer URL is generated thanks to the tenant ID. For active\_directory block, the allowed\_audiences list is filled with a value generated with the name of the App Service. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#auth_settings | `any` | `{}` | no |
| auth\_settings\_v2 | Authentication settings V2. See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#auth_settings_v2 | `any` | `{}` | no |
| client\_affinity\_enabled | Client affinity activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_affinity_enabled | `bool` | `false` | no |
| connection\_strings | Connection strings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string | `list(map(string))` | `[]` | no |
| custom\_name | Override default naming convention | `string` | `null` | no |
| deployment\_mode | Specifies how the infrastructure/resource is deployed | `string` | `"terraform"` | no |
| enable | Set to false to prevent the module from creating any resources. | `bool` | `true` | no |
| enable\_diagnostic | Enable diagnostic settings for Linux Web App | `bool` | `false` | no |
| enable\_private\_endpoint | enable or disable private endpoint to storage account | `bool` | `false` | no |
| enable\_staging\_slot | Enable staging slot for blue-green deployments | `bool` | `false` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `null` | no |
| existing\_service\_plan\_id | If provided, use this existing Service Plan ID instead of creating a new one. | `string` | `null` | no |
| extra\_tags | Variable to pass extra tags. | `map(string)` | `null` | no |
| https\_only | HTTPS restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only | `bool` | `true` | no |
| identity | Map with identity block information. | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | <pre>{<br>  "identity_ids": [],<br>  "type": "SystemAssigned"<br>}</pre> | no |
| ip\_restriction\_default\_action | The default action for traffic that does not match any IP restriction rule. Value must be "Allow" or "Deny". | `string` | `"Deny"` | no |
| ip\_restrictions | A list of IP restrictions to be configured for this web app. | <pre>list(object({<br>    action                    = optional(string, "Allow")<br>    ip_address                = optional(string)<br>    name                      = string<br>    priority                  = number<br>    service_tag               = optional(string)<br>    virtual_network_subnet_id = optional(string)<br>    headers = optional(list(object({<br>      x_azure_fdid      = list(string)<br>      x_fd_health_probe = list(string)<br>      x_forwarded_for   = list(string)<br>      x_forwarded_host  = list(string)<br>      })), [<br>      {<br>        x_azure_fdid      = []<br>        x_fd_health_probe = []<br>        x_forwarded_for   = []<br>        x_forwarded_host  = []<br>      }<br>    ])<br>  }))</pre> | `[]` | no |
| label\_order | The order of labels used to construct resource names or tags. If not specified, defaults to ['name', 'environment', 'location']. | `list(string)` | <pre>[<br>  "name",<br>  "environment",<br>  "location"<br>]</pre> | no |
| linux\_app\_stack | Linux app service stack and Docker configuration | <pre>object({<br>    type                = optional(string, null)<br>    dotnet_version      = optional(string)<br>    node_version        = optional(string)<br>    java_version        = optional(string)<br>    java_server         = optional(string)<br>    java_server_version = optional(string)<br>    php_version         = optional(string)<br>    python_version      = optional(string)<br>    ruby_version        = optional(string)<br>    go_version          = optional(string)<br>    docker = object({<br>      enabled           = bool<br>      image             = optional(string)<br>      registry_url      = optional(string)<br>      registry_username = optional(string)<br>      registry_password = optional(string)<br>    })<br>  })</pre> | `null` | no |
| linux\_sku\_name | SKU name for Linux App Service Plan (e.g. B1, P1V2) | `string` | `"B1"` | no |
| linux\_web\_app\_worker\_count | Linux Web App worker instance count | `number` | `1` | no |
| location | The location/region where the virtual network is created. Changing this forces a new resource to be created. | `string` | `null` | no |
| log\_analytics\_workspace\_id | Log Analytics Workspace ID for diagnostic logs | `string` | `null` | no |
| log\_enabled | Enable log categories for diagnostic settings | `bool` | `true` | no |
| managedby | ManagedBy, eg 'terraform-az-modules'. | `string` | `"terraform-az-modules"` | no |
| maximum\_elastic\_worker\_count | The maximum number of workers to use in an Elastic SKU Plan. Cannot be set unless using an Elastic SKU. | `number` | `null` | no |
| metric\_enabled | Enable metrics for diagnostic settings | `bool` | `true` | no |
| mount\_points | Storage Account mount points. Name is generated if not set and default type is AzureFiles. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#storage_account | `list(map(string))` | `[]` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `null` | no |
| os\_type | The O/S type for the App Services to be hosted in this plan. Possible values include `Windows`, `Linux`, and `WindowsContainer`. | `string` | n/a | yes |
| per\_site\_scaling\_enabled | Should Per Site Scaling be enabled. | `bool` | `false` | no |
| private\_dns\_zone\_ids | Id of the private DNS Zone | `string` | `null` | no |
| private\_endpoint\_subnet\_id | Subnet ID for private endpoint | `string` | `null` | no |
| public\_network\_access\_enabled | Whether enable public access for the App Service. | `bool` | `false` | no |
| read\_permissions | Read permissions for telemetry | `list(string)` | <pre>[<br>  "aggregate",<br>  "api",<br>  "draft",<br>  "extendqueries",<br>  "search"<br>]</pre> | no |
| repository | Terraform current module repo | `string` | `"https://github.com/terraform-az-modules/terraform-azure-vnet"` | no |
| resource\_group\_name | A container that holds related resources for an Azure solution | `string` | `""` | no |
| resource\_position\_prefix | Controls the placement of the resource type keyword (e.g., "vnet", "ddospp") in the resource name.<br><br>- If true, the keyword is prepended: "vnet-core-dev".<br>- If false, the keyword is appended: "core-dev-vnet".<br><br>This helps maintain naming consistency based on organizational preferences. | `bool` | `true` | no |
| scm\_authorized\_ips | SCM IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_authorized\_service\_tags | SCM Service Tags restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_authorized\_subnet\_ids | SCM subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_ip\_restriction\_headers | IPs restriction headers for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#headers | `map(list(string))` | `null` | no |
| site\_config | Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is no more managed in this block. | `any` | `{}` | no |
| staging\_slot\_custom\_app\_settings | Custom app settings for staging slot (if different from production) | `map(string)` | `null` | no |
| staging\_slot\_name | Name of the staging slot | `string` | `"staging"` | no |
| staging\_slot\_public\_access\_enabled | Enable public access to staging slot | `bool` | `false` | no |
| staging\_slot\_site\_config | Site config overrides for staging slot | `any` | `{}` | no |
| storage\_account\_id | Storage Account ID for diagnostic logs (optional) | `string` | `null` | no |
| windows\_app\_stack | Windows app service stack and Docker configuration | <pre>object({<br>    current_stack                = string<br>    python                       = optional(bool)<br>    php_version                  = optional(string)<br>    node_version                 = optional(string)<br>    java_version                 = optional(string)<br>    java_embedded_server_enabled = optional(bool)<br>    tomcat_version               = optional(string)<br>    dotnet_version               = optional(string)<br>    dotnet_core_version          = optional(string)<br>    docker = object({<br>      enabled           = bool<br>      image             = optional(string)<br>      registry_url      = optional(string)<br>      registry_username = optional(string)<br>      registry_password = optional(string)<br>    })<br>  })</pre> | `null` | no |
| windows\_sku\_name | SKU name for Windows App Service Plan (e.g. S1, P1V2) | `string` | `"S1"` | no |
| windows\_web\_app\_worker\_count | Windows Web App worker instance count | `number` | `1` | no |
| worker\_count | The number of Workers (instances) to be allocated. | `number` | `1` | no |
| zone\_balancing\_enabled | n/a | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_service\_default\_site\_hostname | The Default Hostname associated with the App Service |
| app\_service\_id | Id of the App Service |
| app\_service\_name | Name of the App Service |
| app\_service\_outbound\_ip\_addresses | Outbound IP addresses of the App Service |
| app\_service\_possible\_outbound\_ip\_addresses | Possible outbound IP addresses of the App Service |
| app\_service\_site\_credential | Site credential block of the App Service |
| linux\_identity | Managed identity info for Linux web app (empty if not created) |
| windows\_identity | Managed identity info for Windows web app (empty if not created) |


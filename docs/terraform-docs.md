<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.73.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | terraform-az-modules/tags/azurerm | 1.0.2 |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights_api_key.read_telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_api_key) | resource |
| [azurerm_linux_web_app.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |
| [azurerm_linux_web_app_slot.staging](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app_slot) | resource |
| [azurerm_monitor_diagnostic_setting.web_app_diag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_private_endpoint.pep](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.acr_pull](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_service_plan.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_windows_web_app.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app) | resource |
| [azurerm_client_config.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_id"></a> [acr\_id](#input\_acr\_id) | Container registry id to give access to pull images | `string` | `null` | no |
| <a name="input_app_insights_api_key_enable"></a> [app\_insights\_api\_key\_enable](#input\_app\_insights\_api\_key\_enable) | Enable creation of Application Insights API Key | `bool` | `false` | no |
| <a name="input_app_insights_connection_string"></a> [app\_insights\_connection\_string](#input\_app\_insights\_connection\_string) | Connection string of App Insights | `string` | `null` | no |
| <a name="input_app_insights_id"></a> [app\_insights\_id](#input\_app\_insights\_id) | ID of the existing Application Insights resource to use | `string` | `null` | no |
| <a name="input_app_insights_instrumentation_key"></a> [app\_insights\_instrumentation\_key](#input\_app\_insights\_instrumentation\_key) | Instrumentation key of Application Insights | `string` | `null` | no |
| <a name="input_app_service_environment_id"></a> [app\_service\_environment\_id](#input\_app\_service\_environment\_id) | The ID of the App Service Environment to create this Service Plan in. Requires an Isolated SKU. Use one of I1, I2, I3 for azurerm\_app\_service\_environment, or I1v2, I2v2, I3v2 for azurerm\_app\_service\_environment\_v3 | `string` | `null` | no |
| <a name="input_app_service_logs"></a> [app\_service\_logs](#input\_app\_service\_logs) | Configuration of the App Service and App Service Slot logs. Documentation [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#logs) | <pre>object({<br>    detailed_error_messages = optional(bool)<br>    failed_request_tracing  = optional(bool)<br>    application_logs = optional(object({<br>      file_system_level = string<br>      azure_blob_storage = optional(object({<br>        level             = string<br>        retention_in_days = number<br>        sas_url           = string<br>      }))<br>    }))<br>    http_logs = optional(object({<br>      azure_blob_storage = optional(object({<br>        retention_in_days = number<br>        sas_url           = string<br>      }))<br>      file_system = optional(object({<br>        retention_in_days = number<br>        retention_in_mb   = number<br>      }))<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_app_service_vnet_integration_subnet_id"></a> [app\_service\_vnet\_integration\_subnet\_id](#input\_app\_service\_vnet\_integration\_subnet\_id) | Id of the subnet to associate with the app service | `string` | `null` | no |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | Application settings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings | `map(string)` | `{}` | no |
| <a name="input_application_insights_enabled"></a> [application\_insights\_enabled](#input\_application\_insights\_enabled) | Enable Application Insights integration | `bool` | `true` | no |
| <a name="input_auth_settings"></a> [auth\_settings](#input\_auth\_settings) | Authentication settings. Issuer URL is generated thanks to the tenant ID. For active\_directory block, the allowed\_audiences list is filled with a value generated with the name of the App Service. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#auth_settings | `any` | `{}` | no |
| <a name="input_auth_settings_v2"></a> [auth\_settings\_v2](#input\_auth\_settings\_v2) | Authentication settings V2. See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#auth_settings_v2 | `any` | `{}` | no |
| <a name="input_client_affinity_enabled"></a> [client\_affinity\_enabled](#input\_client\_affinity\_enabled) | Client affinity activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_affinity_enabled | `bool` | `false` | no |
| <a name="input_condition"></a> [condition](#input\_condition) | Condition for the role assignment. | `string` | `null` | no |
| <a name="input_condition_version"></a> [condition\_version](#input\_condition\_version) | Condition version for the role assignment. | `string` | `null` | no |
| <a name="input_connection_strings"></a> [connection\_strings](#input\_connection\_strings) | Connection strings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string | `list(map(string))` | `[]` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | Override default naming convention | `string` | `null` | no |
| <a name="input_custom_network_interface_name"></a> [custom\_network\_interface\_name](#input\_custom\_network\_interface\_name) | Custom network interface name for azurerm\_private\_endpoint for provider v4+ | `string` | `null` | no |
| <a name="input_deployment_mode"></a> [deployment\_mode](#input\_deployment\_mode) | Specifies how the infrastructure/resource is deployed | `string` | `"terraform"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description for the role assignment. | `string` | `null` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Set to false to prevent the module from creating any resources. | `bool` | `true` | no |
| <a name="input_enable_diagnostic"></a> [enable\_diagnostic](#input\_enable\_diagnostic) | Enable diagnostic settings for Linux Web App | `bool` | `false` | no |
| <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint) | enable or disable private endpoint to storage account | `bool` | `false` | no |
| <a name="input_enable_staging_slot"></a> [enable\_staging\_slot](#input\_enable\_staging\_slot) | Enable staging slot for blue-green deployments | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `null` | no |
| <a name="input_eventhub_authorization_rule_id"></a> [eventhub\_authorization\_rule\_id](#input\_eventhub\_authorization\_rule\_id) | Eventhub authorization rule ID for azurerm\_monitor\_diagnostic\_setting for provider v4+ | `string` | `null` | no |
| <a name="input_eventhub_name"></a> [eventhub\_name](#input\_eventhub\_name) | Eventhub name for azurerm\_monitor\_diagnostic\_setting for provider v4+ | `string` | `null` | no |
| <a name="input_existing_service_plan_id"></a> [existing\_service\_plan\_id](#input\_existing\_service\_plan\_id) | If provided, use this existing Service Plan ID instead of creating a new one. | `string` | `null` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Variable to pass extra tags. | `map(string)` | `null` | no |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | HTTPS restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only | `bool` | `true` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Map with identity block information. | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | <pre>{<br>  "identity_ids": [],<br>  "type": "SystemAssigned"<br>}</pre> | no |
| <a name="input_ip_restriction_default_action"></a> [ip\_restriction\_default\_action](#input\_ip\_restriction\_default\_action) | The default action for traffic that does not match any IP restriction rule. Value must be "Allow" or "Deny". | `string` | `"Deny"` | no |
| <a name="input_ip_restrictions"></a> [ip\_restrictions](#input\_ip\_restrictions) | A list of IP restrictions to be configured for this web app. | <pre>list(object({<br>    action                    = optional(string, "Allow")<br>    ip_address                = optional(string)<br>    name                      = string<br>    priority                  = number<br>    service_tag               = optional(string)<br>    virtual_network_subnet_id = optional(string)<br>    headers = optional(list(object({<br>      x_azure_fdid      = list(string)<br>      x_fd_health_probe = list(string)<br>      x_forwarded_for   = list(string)<br>      x_forwarded_host  = list(string)<br>      })), [<br>      {<br>        x_azure_fdid      = []<br>        x_fd_health_probe = []<br>        x_forwarded_for   = []<br>        x_forwarded_host  = []<br>      }<br>    ])<br>  }))</pre> | `[]` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order of labels used to construct resource names or tags. If not specified, defaults to ['name', 'environment', 'location']. | `list(string)` | <pre>[<br>  "name",<br>  "environment",<br>  "location"<br>]</pre> | no |
| <a name="input_linux_app_stack"></a> [linux\_app\_stack](#input\_linux\_app\_stack) | Linux app service stack and Docker configuration | <pre>object({<br>    type                = optional(string, null)<br>    dotnet_version      = optional(string)<br>    node_version        = optional(string)<br>    java_version        = optional(string)<br>    java_server         = optional(string)<br>    java_server_version = optional(string)<br>    php_version         = optional(string)<br>    python_version      = optional(string)<br>    ruby_version        = optional(string)<br>    go_version          = optional(string)<br>    docker = object({<br>      enabled           = bool<br>      image             = optional(string)<br>      registry_url      = optional(string)<br>      registry_username = optional(string)<br>      registry_password = optional(string)<br>    })<br>  })</pre> | `null` | no |
| <a name="input_linux_sku_name"></a> [linux\_sku\_name](#input\_linux\_sku\_name) | SKU name for Linux App Service Plan (e.g. B1, P1V2) | `string` | `"B1"` | no |
| <a name="input_linux_web_app_worker_count"></a> [linux\_web\_app\_worker\_count](#input\_linux\_web\_app\_worker\_count) | Linux Web App worker instance count | `number` | `1` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the virtual network is created. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_log_analytics_destination_type"></a> [log\_analytics\_destination\_type](#input\_log\_analytics\_destination\_type) | Log analytics destination type for azurerm\_monitor\_diagnostic\_setting for provider v4+ | `string` | `null` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics Workspace ID for diagnostic logs | `string` | `null` | no |
| <a name="input_log_enabled"></a> [log\_enabled](#input\_log\_enabled) | Enable log categories for diagnostic settings | `bool` | `true` | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'terraform-az-modules'. | `string` | `"terraform-az-modules"` | no |
| <a name="input_maximum_elastic_worker_count"></a> [maximum\_elastic\_worker\_count](#input\_maximum\_elastic\_worker\_count) | The maximum number of workers to use in an Elastic SKU Plan. Cannot be set unless using an Elastic SKU. | `number` | `null` | no |
| <a name="input_metric_enabled"></a> [metric\_enabled](#input\_metric\_enabled) | Enable metrics for diagnostic settings | `bool` | `true` | no |
| <a name="input_mount_points"></a> [mount\_points](#input\_mount\_points) | Storage Account mount points. Name is generated if not set and default type is AzureFiles. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#storage_account | `list(map(string))` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `null` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | The O/S type for the App Services to be hosted in this plan. Possible values include `Windows`, `Linux`, and `WindowsContainer`. | `string` | n/a | yes |
| <a name="input_per_site_scaling_enabled"></a> [per\_site\_scaling\_enabled](#input\_per\_site\_scaling\_enabled) | Should Per Site Scaling be enabled. | `bool` | `false` | no |
| <a name="input_premium_plan_auto_scale_enabled"></a> [premium\_plan\_auto\_scale\_enabled](#input\_premium\_plan\_auto\_scale\_enabled) | Enable auto scale for premium plan in azurerm\_service\_plan for provider v4+ | `bool` | `false` | no |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | Id of the private DNS Zone | `string` | `null` | no |
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | Subnet ID for private endpoint | `string` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether enable public access for the App Service. | `bool` | `false` | no |
| <a name="input_read_permissions"></a> [read\_permissions](#input\_read\_permissions) | Read permissions for telemetry | `list(string)` | <pre>[<br>  "aggregate",<br>  "api",<br>  "draft",<br>  "extendqueries",<br>  "search"<br>]</pre> | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/terraform-az-modules/terraform-azure-vnet"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | A container that holds related resources for an Azure solution | `string` | `""` | no |
| <a name="input_resource_position_prefix"></a> [resource\_position\_prefix](#input\_resource\_position\_prefix) | Controls the placement of the resource type keyword (e.g., "vnet", "ddospp") in the resource name.<br><br>- If true, the keyword is prepended: "vnet-core-dev".<br>- If false, the keyword is appended: "core-dev-vnet".<br><br>This helps maintain naming consistency based on organizational preferences. | `bool` | `true` | no |
| <a name="input_scm_authorized_ips"></a> [scm\_authorized\_ips](#input\_scm\_authorized\_ips) | SCM IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction | `list(string)` | `[]` | no |
| <a name="input_scm_authorized_service_tags"></a> [scm\_authorized\_service\_tags](#input\_scm\_authorized\_service\_tags) | SCM Service Tags restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction | `list(string)` | `[]` | no |
| <a name="input_scm_authorized_subnet_ids"></a> [scm\_authorized\_subnet\_ids](#input\_scm\_authorized\_subnet\_ids) | SCM subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction | `list(string)` | `[]` | no |
| <a name="input_scm_ip_restriction_headers"></a> [scm\_ip\_restriction\_headers](#input\_scm\_ip\_restriction\_headers) | IPs restriction headers for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#headers | `map(list(string))` | `null` | no |
| <a name="input_site_config"></a> [site\_config](#input\_site\_config) | Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is no more managed in this block. | `any` | `{}` | no |
| <a name="input_staging_slot_custom_app_settings"></a> [staging\_slot\_custom\_app\_settings](#input\_staging\_slot\_custom\_app\_settings) | Custom app settings for staging slot (if different from production) | `map(string)` | `null` | no |
| <a name="input_staging_slot_name"></a> [staging\_slot\_name](#input\_staging\_slot\_name) | Name of the staging slot | `string` | `"staging"` | no |
| <a name="input_staging_slot_public_access_enabled"></a> [staging\_slot\_public\_access\_enabled](#input\_staging\_slot\_public\_access\_enabled) | Enable public access to staging slot | `bool` | `false` | no |
| <a name="input_staging_slot_site_config"></a> [staging\_slot\_site\_config](#input\_staging\_slot\_site\_config) | Site config overrides for staging slot | `any` | `{}` | no |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | Storage Account ID for diagnostic logs (optional) | `string` | `null` | no |
| <a name="input_windows_app_stack"></a> [windows\_app\_stack](#input\_windows\_app\_stack) | Windows app service stack and Docker configuration | <pre>object({<br>    current_stack                = string<br>    python                       = optional(bool)<br>    php_version                  = optional(string)<br>    node_version                 = optional(string)<br>    java_version                 = optional(string)<br>    java_embedded_server_enabled = optional(bool)<br>    tomcat_version               = optional(string)<br>    dotnet_version               = optional(string)<br>    dotnet_core_version          = optional(string)<br>    docker = object({<br>      enabled           = bool<br>      image             = optional(string)<br>      registry_url      = optional(string)<br>      registry_username = optional(string)<br>      registry_password = optional(string)<br>    })<br>  })</pre> | `null` | no |
| <a name="input_windows_sku_name"></a> [windows\_sku\_name](#input\_windows\_sku\_name) | SKU name for Windows App Service Plan (e.g. S1, P1V2) | `string` | `"S1"` | no |
| <a name="input_windows_web_app_worker_count"></a> [windows\_web\_app\_worker\_count](#input\_windows\_web\_app\_worker\_count) | Windows Web App worker instance count | `number` | `1` | no |
| <a name="input_worker_count"></a> [worker\_count](#input\_worker\_count) | The number of Workers (instances) to be allocated. | `number` | `1` | no |
| <a name="input_write_permissions"></a> [write\_permissions](#input\_write\_permissions) | Write permissions for azurerm\_application\_insights\_api\_key for provider v4+ | `list(string)` | `[]` | no |
| <a name="input_zone_balancing_enabled"></a> [zone\_balancing\_enabled](#input\_zone\_balancing\_enabled) | n/a | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_service_default_site_hostname"></a> [app\_service\_default\_site\_hostname](#output\_app\_service\_default\_site\_hostname) | The Default Hostname associated with the App Service |
| <a name="output_app_service_id"></a> [app\_service\_id](#output\_app\_service\_id) | Id of the App Service |
| <a name="output_app_service_name"></a> [app\_service\_name](#output\_app\_service\_name) | Name of the App Service |
| <a name="output_app_service_outbound_ip_addresses"></a> [app\_service\_outbound\_ip\_addresses](#output\_app\_service\_outbound\_ip\_addresses) | Outbound IP addresses of the App Service |
| <a name="output_app_service_possible_outbound_ip_addresses"></a> [app\_service\_possible\_outbound\_ip\_addresses](#output\_app\_service\_possible\_outbound\_ip\_addresses) | Possible outbound IP addresses of the App Service |
| <a name="output_app_service_site_credential"></a> [app\_service\_site\_credential](#output\_app\_service\_site\_credential) | Site credential block of the App Service |
| <a name="output_linux_identity"></a> [linux\_identity](#output\_linux\_identity) | Managed identity info for Linux web app (empty if not created) |
| <a name="output_windows_identity"></a> [windows\_identity](#output\_windows\_identity) | Managed identity info for Windows web app (empty if not created) |
<!-- END_TF_DOCS -->
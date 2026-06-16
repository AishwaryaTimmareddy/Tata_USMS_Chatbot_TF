variable "subscription_id" {
  type    = string
  default = "c5f8a2a5-c92f-4daf-9151-078400953600"
}

variable "tenant_id" {
  type = string
}

variable "location" {
  type    = string
  default = "centralindia"
}

variable "openai_location" {
  type    = string
  default = "eastus"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "project" {
  type    = string
  default = "AIChatbot"
}

variable "owner" {
  type    = string
  default = "USMS_Saffron_IT admin"
}

variable "cost_center" {
  type    = string
  default = "USMS_Saffron_Finance"
}

variable "created_by" {
  type    = string
  default = "TATA"
}

variable "managed_by" {
  type    = string
  default = "Terraform_Automation"
}

variable "key_vault_public_network_access_enabled" {
  description = "Temporarily enable during Key Vault bootstrap, then set false immediately after the secret and private endpoint exist."
  type        = bool
  default     = false
}

variable "acr_public_network_access_enabled" {
  description = "Temporarily enable while bootstrapping the first application image, then set false."
  type        = bool
  default     = false
}

variable "function_storage_public_network_access_enabled" {
  description = "Temporarily enable while Azure creates the Function App content share, then set false."
  type        = bool
  default     = false
}

variable "function_public_network_access_enabled" {
  description = "Temporarily enable while publishing Function code from outside the VNet, then set false."
  type        = bool
  default     = false
}

variable "app_public_network_access_enabled" {
  description = "Temporarily enable while debugging App Service from outside the VNet, then set false."
  type        = bool
  default     = false
}

variable "search_public_network_access_enabled" {
  description = "Temporarily enable while provisioning Search index/indexer objects from outside the VNet, then set false."
  type        = bool
  default     = false
}

variable "openai_public_network_access_enabled" {
  description = "Temporarily enable while Azure AI Search indexer calls the Azure OpenAI embedding deployment, then set false after private Search-to-OpenAI connectivity is in place."
  type        = bool
  default     = false
}

variable "admin_public_ip_ranges" {
  description = "Temporary admin public IP allowlist for Azure Portal data-plane viewing. Keep empty for strict private-only backend access."
  type        = list(string)
  default     = []
}

variable "alert_email_address" {
  type = string
}

variable "monthly_budget_inr" {
  type    = number
  default = 35540
}

variable "admin_object_ids" {
  type    = set(string)
  default = []
}

variable "contributor_object_ids" {
  type    = set(string)
  default = []
}

variable "reader_object_ids" {
  type    = set(string)
  default = []
}

variable "create_bootstrap_users" {
  description = "Create one Entra administrator and one Entra test user."
  type        = bool
  default     = true
}

variable "bootstrap_admin_upn" {
  type    = string
  default = "aichatbot-admin@usmssaffron.onmicrosoft.com"
}

variable "bootstrap_test_upn" {
  type    = string
  default = "aichatbot-test@usmssaffron.onmicrosoft.com"
}

variable "app_gateway_certificate_secret_id" {
  description = "Versionless Key Vault secret ID for the production PFX certificate."
  type        = string
  default     = null
}

variable "app_gateway_host_name" {
  type    = string
  default = null
}

variable "enable_vpn" {
  description = "VPN is excluded by TSD section 5.13. Enable only after written scope approval."
  type        = bool
  default     = false
}

variable "vpn_client_address_space" {
  type    = list(string)
  default = ["172.20.0.0/24"]
}

variable "container_image" {
  description = "App image repository and tag, for example usms-chatbot:1.0.0."
  type        = string
  default     = "usms-chatbot:1.0.0"
}

variable "chat_model_name" {
  type    = string
  default = "gpt-4.1-mini"
}

variable "chat_model_version" {
  type    = string
  default = "2025-04-14"
}

variable "chat_deployment_capacity" {
  description = "Azure OpenAI deployment capacity units for the chat model. Increase only within approved quota."
  type        = number
  default     = 10
}

variable "embedding_model_name" {
  type    = string
  default = "text-embedding-3-large"
}

variable "embedding_model_version" {
  type    = string
  default = "1"
}

variable "embedding_deployment_capacity" {
  description = "Azure OpenAI deployment capacity units for the embedding model. Increase only within approved quota."
  type        = number
  default     = 10
}

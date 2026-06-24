resource "azurerm_search_service" "this" {
  name                          = "srch-aichatbot-prod-cin-001"
  resource_group_name           = var.workload_resource_group_name
  location                      = var.location
  sku                           = "standard"
  replica_count                 = 2
  partition_count               = 1
  public_network_access_enabled = var.search_public_network_access_enabled || length(var.admin_public_ip_ranges) > 0
  allowed_ips                   = var.search_public_network_access_enabled ? [] : var.admin_public_ip_ranges
  local_authentication_enabled  = true
  authentication_failure_mode   = "http401WithBearerChallenge"
  semantic_search_sku           = "standard"
  tags                          = var.tags
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_cognitive_account" "openai" {
  name                          = "oai-aichatbot-prod-eus-001"
  location                      = var.openai_location
  resource_group_name           = var.workload_resource_group_name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  custom_subdomain_name         = "oai-aichatbot-prod-eus-001"
  public_network_access_enabled = var.openai_public_network_access_enabled || length(var.admin_public_ip_ranges) > 0
  tags                          = var.tags
  identity {
    type = "SystemAssigned"
  }
  network_acls {
    bypass         = "AzureServices"
    default_action = var.openai_public_network_access_enabled ? "Allow" : "Deny"
    ip_rules       = var.openai_public_network_access_enabled ? [] : var.admin_public_ip_ranges
  }
}

resource "azapi_resource" "search_openai_shared_private_link" {
  type      = "Microsoft.Search/searchServices/sharedPrivateLinkResources@2024-03-01-preview"
  name      = "spl-openai"
  parent_id = azurerm_search_service.this.id
  body = {
    properties = {
      groupId               = "openai_account"
      privateLinkResourceId = azurerm_cognitive_account.openai.id
      requestMessage        = "Allow Azure AI Search indexer to call Azure OpenAI embedding skill privately."
    }
  }
}

resource "azurerm_cognitive_deployment" "chat" {
  name                 = "chat"
  cognitive_account_id = azurerm_cognitive_account.openai.id
  model {
    format  = "OpenAI"
    name    = var.chat_model_name
    version = var.chat_model_version
  }
  sku {
    name     = "Standard"
    capacity = var.chat_deployment_capacity
  }
}

resource "azurerm_cognitive_deployment" "embedding" {
  name                 = "embedding"
  cognitive_account_id = azurerm_cognitive_account.openai.id
  model {
    format  = "OpenAI"
    name    = var.embedding_model_name
    version = var.embedding_model_version
  }
  sku {
    name     = "Standard"
    capacity = var.embedding_deployment_capacity
  }
}

resource "azurerm_cognitive_account" "content_safety" {
  name                          = "cs-aichatbot-prod-cin-001"
  location                      = var.openai_location
  resource_group_name           = var.workload_resource_group_name
  kind                          = "ContentSafety"
  sku_name                      = "S0"
  custom_subdomain_name         = "cs-aichatbot-prod-cin-001"
  public_network_access_enabled = length(var.admin_public_ip_ranges) > 0
  tags                          = var.tags
  identity {
    type = "SystemAssigned"
  }
  network_acls {
    default_action = "Deny"
    ip_rules       = var.admin_public_ip_ranges
  }
}

locals {
  search_endpoint          = "${azurerm_search_service.this.name}.search.windows.net"
  search_index_name        = "usms-knowledge-index"
  search_data_source_name  = "usms-knowledge-datasource"
  search_skillset_name     = "usms-knowledge-skillset"
  search_indexer_name      = "usms-knowledge-indexer"
  search_api_version       = "2024-07-01"
  document_storage_account = element(reverse(split("/", var.document_storage_account_id)), 0)

  search_index_body = {
    name = local.search_index_name
    fields = [
      {
        name       = "id"
        type       = "Edm.String"
        key        = true
        searchable = true
        filterable = true
        sortable   = true
        facetable  = false
        analyzer   = "keyword"
      },
      {
        name       = "content"
        type       = "Edm.String"
        searchable = true
        filterable = false
        sortable   = false
        facetable  = false
      },
      {
        name       = "parentId"
        type       = "Edm.String"
        searchable = false
        filterable = true
        sortable   = false
        facetable  = false
      },
      {
        name                = "contentVector"
        type                = "Collection(Edm.Single)"
        searchable          = true
        filterable          = false
        sortable            = false
        facetable           = false
        dimensions          = var.embedding_dimensions
        vectorSearchProfile = "default-vector-profile"
      },
      {
        name       = "title"
        type       = "Edm.String"
        searchable = true
        filterable = true
        sortable   = true
        facetable  = false
      },
      {
        name       = "source"
        type       = "Edm.String"
        searchable = true
        filterable = true
        sortable   = true
        facetable  = false
      },
      {
        name       = "category"
        type       = "Edm.String"
        searchable = true
        filterable = true
        sortable   = true
        facetable  = true
      },
      {
        name       = "isApproved"
        type       = "Edm.Boolean"
        searchable = false
        filterable = true
        sortable   = true
        facetable  = true
      },
      {
        name       = "pageNumber"
        type       = "Edm.Int32"
        searchable = false
        filterable = true
        sortable   = true
        facetable  = false
      }
    ]
    vectorSearch = {
      algorithms = [
        {
          name = "default-hnsw"
          kind = "hnsw"
          hnswParameters = {
            metric         = "cosine"
            m              = 4
            efConstruction = 400
            efSearch       = 500
          }
        }
      ]
      profiles = [
        {
          name      = "default-vector-profile"
          algorithm = "default-hnsw"
        }
      ]
    }
    semantic = {
      defaultConfiguration = "default"
      configurations = [
        {
          name = "default"
          prioritizedFields = {
            titleField = {
              fieldName = "title"
            }
            prioritizedContentFields = [
              {
                fieldName = "content"
              }
            ]
            prioritizedKeywordsFields = [
              {
                fieldName = "category"
              }
            ]
          }
        }
      ]
    }
  }

  search_data_source_body = {
    name = local.search_data_source_name
    type = "azureblob"
    credentials = {
      connectionString = "ResourceId=${var.document_storage_account_id};"
    }
    container = {
      name = "knowledge"
    }
    dataDeletionDetectionPolicy = {
      "@odata.type" = "#Microsoft.Azure.Search.NativeBlobSoftDeleteDeletionDetectionPolicy"
    }
  }

  search_skillset_body = {
    name        = local.search_skillset_name
    description = "Chunks approved USMS Saffron documents and generates Azure OpenAI embeddings."
    skills = [
      {
        "@odata.type"       = "#Microsoft.Skills.Text.SplitSkill"
        name                = "split-content"
        description         = "Split extracted document text into embedding-safe chunks."
        context             = "/document"
        defaultLanguageCode = "en"
        textSplitMode       = "pages"
        maximumPageLength   = 3500
        pageOverlapLength   = 100
        maximumPagesToTake  = 0
        inputs = [
          {
            name   = "text"
            source = "/document/content"
          }
        ]
        outputs = [
          {
            name       = "textItems"
            targetName = "pages"
          }
        ]
      },
      {
        "@odata.type"       = "#Microsoft.Skills.Text.PIIDetectionSkill"
        name                = "mask-sensitive-content"
        description         = "Mask personally identifiable information before embedding and indexing."
        context             = "/document/pages/*"
        defaultLanguageCode = "en"
        minimumPrecision    = 0.5
        maskingMode         = "replace"
        maskingCharacter    = "*"
        inputs = [
          {
            name   = "text"
            source = "/document/pages/*"
          }
        ]
        outputs = [
          {
            name       = "maskedText"
            targetName = "maskedText"
          },
          {
            name       = "piiEntities"
            targetName = "piiEntities"
          }
        ]
      },
      {
        "@odata.type" = "#Microsoft.Skills.Text.AzureOpenAIEmbeddingSkill"
        name          = "embed-content"
        description   = "Generate vectors from masked content using the production embedding deployment."
        context       = "/document/pages/*"
        resourceUri   = trimsuffix(azurerm_cognitive_account.openai.endpoint, "/")
        deploymentId  = azurerm_cognitive_deployment.embedding.name
        modelName     = var.embedding_model_name
        dimensions    = var.embedding_dimensions
        inputs = [
          {
            name   = "text"
            source = "/document/pages/*/maskedText"
          }
        ]
        outputs = [
          {
            name       = "embedding"
            targetName = "contentVector"
          }
        ]
      }
    ]
    indexProjections = {
      selectors = [
        {
          targetIndexName    = local.search_index_name
          parentKeyFieldName = "parentId"
          sourceContext      = "/document/pages/*"
          mappings = [
            {
              name   = "content"
              source = "/document/pages/*/maskedText"
            },
            {
              name   = "contentVector"
              source = "/document/pages/*/contentVector"
            },
            {
              name   = "title"
              source = "/document/metadata_storage_name"
            },
            {
              name   = "source"
              source = "/document/metadata_storage_path"
            }
          ]
        }
      ]
      parameters = {
        projectionMode = "skipIndexingParentDocuments"
      }
    }
  }

  search_indexer_body = {
    name            = local.search_indexer_name
    description     = "Indexes approved knowledge documents from the private knowledge blob container."
    dataSourceName  = local.search_data_source_name
    targetIndexName = local.search_index_name
    skillsetName    = local.search_skillset_name
    parameters = {
      batchSize = 1
      configuration = {
        dataToExtract                = "contentAndMetadata"
        parsingMode                  = "default"
        indexedFileNameExtensions    = ".pdf,.docx,.doc,.txt,.md,.html,.htm"
        failOnUnsupportedContentType = false
        failOnUnprocessableDocument  = false
      }
    }
    fieldMappings = [
      {
        sourceFieldName = "content"
        targetFieldName = "content"
      },
      {
        sourceFieldName = "metadata_storage_path"
        targetFieldName = "id"
        mappingFunction = {
          name = "base64Encode"
        }
      },
      {
        sourceFieldName = "metadata_storage_name"
        targetFieldName = "title"
      },
      {
        sourceFieldName = "metadata_storage_path"
        targetFieldName = "source"
      },
      {
        sourceFieldName = "metadata_category"
        targetFieldName = "category"
      },
      {
        sourceFieldName = "metadata_approved"
        targetFieldName = "isApproved"
      }
    ]
  }
}

resource "terraform_data" "search_index" {
  count            = var.manage_search_data_plane ? 1 : 0
  triggers_replace = [sha256(jsonencode(local.search_index_body))]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]
    command     = <<-EOT
      $ErrorActionPreference = "Stop"
      $body = @'
      ${jsonencode(local.search_index_body)}
      '@
      $path = Join-Path $env:TEMP "usms-search-index.json"
      Set-Content -LiteralPath $path -Value $body -Encoding UTF8
      az rest --resource "https://search.azure.com" --method delete --url "https://${local.search_endpoint}/indexes/${local.search_index_name}?api-version=${local.search_api_version}" --output none 2>$null
      Start-Sleep -Seconds 10
      az rest --resource "https://search.azure.com" --method put --url "https://${local.search_endpoint}/indexes/${local.search_index_name}?api-version=${local.search_api_version}" --body "@$path" --output none
      if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
      Remove-Item -LiteralPath $path -Force
    EOT
  }
}

resource "terraform_data" "search_data_source" {
  count            = 1
  triggers_replace = [sha256(jsonencode(local.search_data_source_body))]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]
    command     = <<-EOT
      $ErrorActionPreference = "Stop"
      $body = @'
      ${jsonencode(local.search_data_source_body)}
      '@
      $path = Join-Path $env:TEMP "usms-search-data-source.json"
      Set-Content -LiteralPath $path -Value $body -Encoding UTF8
      az rest --resource "https://search.azure.com" --method put --url "https://${local.search_endpoint}/datasources/${local.search_data_source_name}?api-version=${local.search_api_version}" --body "@$path" --output none
      if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
      Remove-Item -LiteralPath $path -Force
    EOT
  }

  depends_on = [azurerm_role_assignment.this]
}

resource "terraform_data" "search_skillset" {
  count            = var.manage_search_data_plane ? 1 : 0
  triggers_replace = [sha256(jsonencode(local.search_skillset_body))]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]
    command     = <<-EOT
      $ErrorActionPreference = "Stop"
      $body = @'
      ${jsonencode(local.search_skillset_body)}
      '@
      $path = Join-Path $env:TEMP "usms-search-skillset.json"
      Set-Content -LiteralPath $path -Value $body -Encoding UTF8
      az rest --resource "https://search.azure.com" --method put --url "https://${local.search_endpoint}/skillsets/${local.search_skillset_name}?api-version=${local.search_api_version}" --body "@$path" --output none
      if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
      Remove-Item -LiteralPath $path -Force
    EOT
  }

  depends_on = [
    azurerm_cognitive_deployment.embedding,
    azurerm_role_assignment.this,
    terraform_data.search_index
  ]
}

resource "terraform_data" "search_indexer" {
  count            = var.manage_search_data_plane ? 1 : 0
  triggers_replace = [sha256(jsonencode(local.search_indexer_body))]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]
    command     = <<-EOT
      $ErrorActionPreference = "Stop"
      $body = @'
      ${jsonencode(local.search_indexer_body)}
      '@
      $path = Join-Path $env:TEMP "usms-search-indexer.json"
      Set-Content -LiteralPath $path -Value $body -Encoding UTF8
      az rest --resource "https://search.azure.com" --method put --url "https://${local.search_endpoint}/indexers/${local.search_indexer_name}?api-version=${local.search_api_version}" --body "@$path" --output none
      if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
      Remove-Item -LiteralPath $path -Force
    EOT
  }

  depends_on = [
    terraform_data.search_index,
    terraform_data.search_data_source,
    terraform_data.search_skillset
  ]
}

resource "azapi_resource" "foundry" {
  type      = "Microsoft.CognitiveServices/accounts@2025-06-01"
  name      = "aif-aichatbot-prod-cin-001"
  parent_id = var.workload_resource_group_id
  location  = var.location
  tags      = var.tags
  body = {
    kind = "AIServices"
    sku = {
      name = "S0"
    }
    identity = {
      type = "SystemAssigned"
    }
    properties = {
      allowProjectManagement        = true
      customSubDomainName           = "aif-aichatbot-prod-cin-001"
      publicNetworkAccess           = "Disabled"
      restrictOutboundNetworkAccess = true
    }
  }
}

resource "azapi_resource" "foundry_project" {
  type      = "Microsoft.CognitiveServices/accounts/projects@2025-06-01"
  name      = "proj-aichatbot-prod-cin-001"
  parent_id = azapi_resource.foundry.id
  location  = var.location
  tags      = var.tags
  body = {
    identity = {
      type = "SystemAssigned"
    }
    properties = {
      displayName = "USMS Saffron AI Chatbot Production"
      description = "Production Foundry project managed by Terraform."
    }
  }
}

locals {
  endpoints = {
    search         = { id = azurerm_search_service.this.id, service = "searchService", dns = "search" }
    openai         = { id = azurerm_cognitive_account.openai.id, service = "account", dns = "openai" }
    content_safety = { id = azurerm_cognitive_account.content_safety.id, service = "account", dns = "cognitive" }
    foundry        = { id = azapi_resource.foundry.id, service = "account", dns = "cognitive" }
  }
  roles = {
    app_search         = { scope = azurerm_search_service.this.id, role = "Search Index Data Reader", principal = var.app_identity_principal_id }
    app_search_writer  = { scope = azurerm_search_service.this.id, role = "Search Index Data Contributor", principal = var.app_identity_principal_id }
    app_search_service = { scope = azurerm_search_service.this.id, role = "Search Service Contributor", principal = var.app_identity_principal_id }
    function_search    = { scope = azurerm_search_service.this.id, role = "Search Service Contributor", principal = var.function_identity_principal_id }
    app_openai         = { scope = azurerm_cognitive_account.openai.id, role = "Cognitive Services OpenAI User", principal = var.app_identity_principal_id }
    app_content_safety = { scope = azurerm_cognitive_account.content_safety.id, role = "Cognitive Services User", principal = var.app_identity_principal_id }
    search_blob        = { scope = var.document_storage_account_id, role = "Storage Blob Data Reader", principal = azurerm_search_service.this.identity[0].principal_id }
    search_openai      = { scope = azurerm_cognitive_account.openai.id, role = "Cognitive Services OpenAI User", principal = azurerm_search_service.this.identity[0].principal_id }
  }
}

resource "azurerm_private_endpoint" "this" {
  for_each            = local.endpoints
  name                = "pe-aichatbot-prod-cin-${each.key}-001"
  location            = var.location
  resource_group_name = var.network_resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags
  private_service_connection {
    name                           = "psc-${each.key}"
    private_connection_resource_id = each.value.id
    subresource_names              = [each.value.service]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids[each.value.dns]]
  }
}

resource "azurerm_role_assignment" "this" {
  for_each             = local.roles
  scope                = each.value.scope
  role_definition_name = each.value.role
  principal_id         = each.value.principal
}

# USMS Saffron 50-User Load Test

This test uses Azure Load Testing and Apache JMeter to simulate 50 concurrent
anonymous chatbot users.

## Test profile

- Virtual users: 50
- Ramp-up: 60 seconds
- Requests per user: 3
- Total planned chat requests: 150
- Test engines: 1
- User think time: 1-3 seconds
- Target: Application Gateway public endpoint

## Pass criteria

- p90 chatbot response time is 5 seconds or less.
- Average chatbot response time is 5 seconds or less.
- Error rate is 5 percent or less.
- The run automatically stops if the error rate exceeds 20 percent for 60 seconds.

## Provision the Azure resource

Register the Azure Load Testing provider once:

```powershell
az provider register --namespace Microsoft.LoadTestService --wait
```

Then run the normal reviewed Terraform workflow:

```powershell
terraform plan -out=tfplan-load-testing
terraform apply tfplan-load-testing
```

## Create or update the test

Install the Azure Load Testing CLI extension once:

```powershell
az extension add --name load
```

From the Terraform root:

```powershell
az load test create `
  --load-test-resource lt-aichatbot-prod-cin-001 `
  --resource-group rg-aichatbot-prod-cin-monitoring-001 `
  --test-id saffron-chat-50-users `
  --load-test-config-file .\load-tests\saffron-chat-50-users.yaml
```

## Run the test

Use a unique test-run ID:

```powershell
$runId = "saffron-50u-" + (Get-Date -Format "yyyyMMdd-HHmmss")

az load test-run create `
  --load-test-resource lt-aichatbot-prod-cin-001 `
  --resource-group rg-aichatbot-prod-cin-monitoring-001 `
  --test-id saffron-chat-50-users `
  --test-run-id $runId `
  --display-name "USMS Saffron 50 Users $(Get-Date -Format 'yyyy-MM-dd HH:mm')" `
  --description "Approved production performance validation"
```

Do not run the test without an approved production test window. Fifty concurrent
users can consume Azure OpenAI quota and trigger the configured performance alerts.

Before rerunning after HTTP 429 throttling, confirm that the production Azure OpenAI
deployments have sufficient capacity. The current approved test allocation is:

- GPT-4.1-mini chat deployment: 300 capacity units.
- text-embedding-3-large deployment: 50 capacity units.

## Azure portal results

Open:

`Azure Portal > Azure Load Testing > lt-aichatbot-prod-cin-001 > Tests >
saffron-chat-50-users`

Capture:

- Test summary and pass/fail result.
- Response-time percentiles.
- Error percentage and error details.
- Throughput.
- Engine health.
- App Service, Application Insights, AI Search, and Azure OpenAI metrics.

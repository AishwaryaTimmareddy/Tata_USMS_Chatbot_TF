#!/usr/bin/env bash

# Reusable Terraform build workflow.
# Default behavior is safe: init, format check, validate, and plan only.
# Infrastructure is changed only when --apply is explicitly supplied.

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

export TF_IN_AUTOMATION=1

ACTION="plan"
VAR_FILE="terraform.tfvars"
PLAN_FILE="terraform.tfplan"
WORKSPACE=""
PARALLELISM="10"
LOCK_TIMEOUT="5m"

AUTO_APPROVE=false
FORMAT_FILES=false
SKIP_FORMAT=false
SKIP_VALIDATE=false
UPGRADE=false
RECONFIGURE=false
INIT_ONLY=false
SHOW_PLAN=false
CHECK_AZURE=false

declare -a BACKEND_CONFIGS=()
declare -a TARGETS=()

usage() {
  cat <<'EOF'
Usage:
  ./build.sh [options]

Default workflow:
  terraform fmt -check -recursive
  terraform init
  terraform validate
  terraform plan -out=terraform.tfplan

Options:
  --apply                 Apply the saved plan after a successful plan.
  --auto-approve          Do not prompt before applying. Requires --apply.
  --init-only             Stop after terraform init and workspace selection.
  --format                Run terraform fmt -recursive instead of fmt -check.
  --skip-format           Skip Terraform formatting checks.
  --skip-validate         Skip terraform validate.
  --upgrade               Pass -upgrade to terraform init.
  --reconfigure           Pass -reconfigure to terraform init.
  --check-azure           Verify Azure CLI authentication before Terraform.
  --show-plan             Print the complete human-readable saved plan.

  --var-file FILE         Terraform variable file.
                          Default: terraform.tfvars
  --plan-file FILE        Saved plan path.
                          Default: terraform.tfplan
  --workspace NAME        Select or create a Terraform workspace.
  --backend-config VALUE  Pass a backend configuration to terraform init.
                          May be provided more than once.
  --target ADDRESS        Pass a resource target to terraform plan.
                          May be provided more than once. Use sparingly.
  --parallelism NUMBER    Terraform operation parallelism.
                          Default: 10
  --lock-timeout VALUE    State lock timeout.
                          Default: 5m

  -h, --help              Display this help.

Examples:
  ./build.sh
  ./build.sh --var-file environments/prod.tfvars
  ./build.sh --workspace prod --plan-file prod.tfplan
  ./build.sh --backend-config backend-prod.hcl --reconfigure
  ./build.sh --apply
  ./build.sh --apply --auto-approve

Recommended CI usage:
  ./build.sh \
    --var-file environments/prod.tfvars \
    --workspace prod \
    --plan-file prod.tfplan

Notes:
  - Review the saved plan before using --apply.
  - Do not commit tfvars, state files, plan files, credentials, or secrets.
  - This script intentionally does not provide a destroy operation.
EOF
}

log() {
  printf '\n[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

fail() {
  printf '\nERROR: %s\n' "$*" >&2
  exit 1
}

on_error() {
  local exit_code=$?
  printf '\nTerraform workflow failed at line %s with exit code %s.\n' \
    "${BASH_LINENO[0]:-unknown}" "$exit_code" >&2
  exit "$exit_code"
}

trap on_error ERR

require_value() {
  local option="$1"
  local value="${2:-}"
  [[ -n "$value" ]] || fail "$option requires a value."
}

while (($# > 0)); do
  case "$1" in
    --apply)
      ACTION="apply"
      shift
      ;;
    --auto-approve)
      AUTO_APPROVE=true
      shift
      ;;
    --init-only)
      INIT_ONLY=true
      shift
      ;;
    --format)
      FORMAT_FILES=true
      shift
      ;;
    --skip-format)
      SKIP_FORMAT=true
      shift
      ;;
    --skip-validate)
      SKIP_VALIDATE=true
      shift
      ;;
    --upgrade)
      UPGRADE=true
      shift
      ;;
    --reconfigure)
      RECONFIGURE=true
      shift
      ;;
    --check-azure)
      CHECK_AZURE=true
      shift
      ;;
    --show-plan)
      SHOW_PLAN=true
      shift
      ;;
    --var-file)
      require_value "$1" "${2:-}"
      VAR_FILE="$2"
      shift 2
      ;;
    --plan-file)
      require_value "$1" "${2:-}"
      PLAN_FILE="$2"
      shift 2
      ;;
    --workspace)
      require_value "$1" "${2:-}"
      WORKSPACE="$2"
      shift 2
      ;;
    --backend-config)
      require_value "$1" "${2:-}"
      BACKEND_CONFIGS+=("$2")
      shift 2
      ;;
    --target)
      require_value "$1" "${2:-}"
      TARGETS+=("$2")
      shift 2
      ;;
    --parallelism)
      require_value "$1" "${2:-}"
      PARALLELISM="$2"
      shift 2
      ;;
    --lock-timeout)
      require_value "$1" "${2:-}"
      LOCK_TIMEOUT="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown option: $1. Use --help for supported options."
      ;;
  esac
done

if $AUTO_APPROVE && [[ "$ACTION" != "apply" ]]; then
  fail "--auto-approve can only be used together with --apply."
fi

if ! [[ "$PARALLELISM" =~ ^[1-9][0-9]*$ ]]; then
  fail "--parallelism must be a positive integer."
fi

command -v terraform >/dev/null 2>&1 ||
  fail "Terraform is not installed or is not available in PATH."

if $CHECK_AZURE; then
  command -v az >/dev/null 2>&1 ||
    fail "Azure CLI is not installed or is not available in PATH."
  log "Checking Azure CLI authentication"
  az account show --output none ||
    fail "Azure CLI is not authenticated. Run 'az login' first."
fi

log "Terraform version"
terraform version

if [[ -n "$VAR_FILE" && ! -f "$VAR_FILE" ]]; then
  fail "Variable file not found: $VAR_FILE"
fi

if ! $SKIP_FORMAT; then
  if $FORMAT_FILES; then
    log "Formatting Terraform files"
    terraform fmt -recursive
  else
    log "Checking Terraform formatting"
    terraform fmt -check -recursive
  fi
fi

declare -a INIT_ARGS=("-input=false")

if $UPGRADE; then
  INIT_ARGS+=("-upgrade")
fi

if $RECONFIGURE; then
  INIT_ARGS+=("-reconfigure")
fi

for config in "${BACKEND_CONFIGS[@]}"; do
  INIT_ARGS+=("-backend-config=$config")
done

log "Initializing Terraform"
terraform init "${INIT_ARGS[@]}"

if [[ -n "$WORKSPACE" ]]; then
  log "Selecting Terraform workspace: $WORKSPACE"
  if ! terraform workspace select "$WORKSPACE"; then
    terraform workspace new "$WORKSPACE"
  fi
fi

if $INIT_ONLY; then
  log "Initialization completed"
  exit 0
fi

if ! $SKIP_VALIDATE; then
  log "Validating Terraform configuration"
  terraform validate
fi

declare -a PLAN_ARGS=(
  "-input=false"
  "-lock-timeout=$LOCK_TIMEOUT"
  "-parallelism=$PARALLELISM"
  "-out=$PLAN_FILE"
  "-detailed-exitcode"
)

if [[ -n "$VAR_FILE" ]]; then
  PLAN_ARGS+=("-var-file=$VAR_FILE")
fi

for target in "${TARGETS[@]}"; do
  PLAN_ARGS+=("-target=$target")
done

log "Creating Terraform plan: $PLAN_FILE"
if terraform plan "${PLAN_ARGS[@]}"; then
  PLAN_EXIT_CODE=0
else
  PLAN_EXIT_CODE=$?
fi

case "$PLAN_EXIT_CODE" in
  0)
    PLAN_HAS_CHANGES=false
    log "Terraform plan completed: no infrastructure changes"
    ;;
  2)
    PLAN_HAS_CHANGES=true
    log "Terraform plan completed: changes are present"
    ;;
  *)
    fail "terraform plan failed with exit code $PLAN_EXIT_CODE."
    ;;
esac

if $SHOW_PLAN; then
  log "Displaying saved Terraform plan"
  terraform show -no-color "$PLAN_FILE"
fi

if [[ "$ACTION" == "plan" ]]; then
  log "Plan-only workflow completed"
  printf 'Saved plan: %s\n' "$PLAN_FILE"
  printf 'Review it with: terraform show %q\n' "$PLAN_FILE"
  printf 'Apply it with:  terraform apply %q\n' "$PLAN_FILE"
  exit 0
fi

if ! $PLAN_HAS_CHANGES; then
  log "No changes to apply"
  exit 0
fi

declare -a APPLY_ARGS=(
  "-input=false"
  "-lock-timeout=$LOCK_TIMEOUT"
  "-parallelism=$PARALLELISM"
)

if $AUTO_APPROVE; then
  APPLY_ARGS+=("-auto-approve")
fi

log "Applying saved Terraform plan"
terraform apply "${APPLY_ARGS[@]}" "$PLAN_FILE"

log "Terraform apply completed successfully"
terraform output

.PHONY: help docs fmt

TFPATH ?= terraform
p ?= $(TFPATH)

help: ## Show this help
	@echo "Terraform Documentation Generator"
	@echo ""
	@echo "Usage: make docs [p=path] or make fmt [p=path]"
	@echo "Default path: terraform/"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "}; /^[a-zA-Z0-9_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

docs: ## Generate terraform-docs
	@if ! command -v terraform-docs >/dev/null 2>&1; then echo "terraform-docs not installed. Run: brew install terraform-docs"; exit 1; fi
	@echo "Generating documentation for $(p)..."
	@terraform-docs markdown $(p) > README.md
	@echo "Documentation updated in README.md"

fmt: ## Format Terraform files
	@echo "Formatting Terraform files in $(p)..."
	@terraform fmt -recursive $(p)/
	@echo "Terraform files formatted"

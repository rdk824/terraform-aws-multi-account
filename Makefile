.PHONY: $(shell grep --no-filename -E '^[a-zA-Z0-9_-]+:' $(MAKEFILE_LIST) | sed 's/://')

SHELL=/bin/bash

# Define paths variables
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SCRIPTS := $(ROOT_DIR)scripts

# AWS Environments
RESOURCE_DIR := $(ROOT_DIR)environments/$(RESOURCE)

# Terraform files
TF_CLI_CONFIGURATION := $(HOME)/.terraformrc
TF_PLUGIN_CACHE_DIR := $(HOME)/.terraform.d/plugins

# Terraform commands
TF_GET := terraform get -update
TF_SHOW := terraform show
TF_GRAPH := terraform graph -draw-cycles -verbose
TF_INIT := terraform init
TF_PLAN := terraform plan
TF_APPLY := terraform apply -auto-approve
TF_REFRESH := terraform refresh
TF_DESTROY := terraform destroy -force -auto-approve

export


setup_env: check_aws_profile check_resource_dir
	@if [ ! -d $(TF_PLUGIN_CACHE_DIR) ]; then \
		mkdir -p $(TF_PLUGIN_CACHE_DIR); \
	fi
	@echo 'plugin_cache_dir = "$(TF_PLUGIN_CACHE_DIR)"' > $(TF_CLI_CONFIGURATION)
	@cd $(RESOURCE_DIR); \
	$(SCRIPTS)/set_vars.sh

check_aws_profile:
	@if ! aws sts get-caller-identity --output text --query 'Account' > /dev/null 2>&1 ; then \
	  echo "ERROR: AWS profile \"${AWS_PROFILE}\" is not setup!"; \
	  exit 1 ; \
	fi

check_resource_dir:
	@if [ ! -d $(RESOURCE_DIR) ] >/dev/null 2>&1 ; then \
	  printf "\n\033[31mERROR:  %s not found! Create the folder before proceeding!\n\n" ${RESOURCE_DIR}; \
	  exit 1 ; \
	fi

tf_init: setup_env tf_remote_state
	cd $(RESOURCE_DIR); \
	rm -rf .terraform; \
	$(TF_INIT); \
	terraform workspace select default; \
	terraform workspace select $(ENV) || terraform workspace new $(ENV); \
	$(TF_GET)

tf_plan: tf_init
	cd $(RESOURCE_DIR); \
	$(TF_PLAN)

tf_apply: tf_plan
	cd $(RESOURCE_DIR); \
	$(TF_APPLY)

tf_remote_state:
	cd $(RESOURCE_DIR); \
	$(SCRIPTS)/tf_remote_state.sh
	
tf_refresh: tf_init
	$(TF_REFRESH)

tf_destroy: tf_init
	cd $(RESOURCE_DIR); \
	$(TF_DESTROY)

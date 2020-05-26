# SHELL=/bin/bash


# Define paths variables
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SCRIPTS := $(ROOT_DIR)scripts

# AWS Environments
AWS_ENV_DIR := $(ROOT_DIR)environments

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



init: setup_env
	@if [ ! -d $(TF_PLUGIN_CACHE_DIR) ]; then \
		mkdir -p $(TF_PLUGIN_CACHE_DIR); \
	fi
	@echo 'plugin_cache_dir = "$(TF_PLUGIN_CACHE_DIR)"' > $(TF_CLI_CONFIGURATION)

setup_env: check_aws_profile
	cd $(AWS_ENV_DIR)/$(RESOURCE); \
	$(SCRIPTS)/set_vars.sh

check_aws_profile:
	@if ! aws sts get-caller-identity --output text --query 'Account' > /dev/null 2>&1 ; then \
	  echo "ERROR: AWS profile \"${AWS_PROFILE}\" is not setup!"; \
	  exit 1 ; \
	fi




tf_init: init tf_workspace tf_remote_state
	cd $(AWS_ENV_DIR)/$(RESOURCE); \
	$(TF_INIT); $(TF_GET);

tf_plan: tf_init
	cd $(AWS_ENV_DIR)/$(RESOURCE); \
	$(TF_PLAN)

tf_apply: tf_plan
	cd $(AWS_ENV_DIR)/$(RESOURCE); \
	$(TF_APPLY)

tf_remote_state:
	cd $(AWS_ENV_DIR)/$(RESOURCE); \
	$(SCRIPTS)/tf_remote_state.sh

# https://github.com/hashicorp/terraform/issues/21393
tf_workspace:
	cd $(AWS_ENV_DIR)/$(RESOURCE); \
	terraform workspace select default; \
	terraform workspace select $(ENV) || terraform workspace new $(ENV); \
	$(TF_INIT);
	
tf_refresh: tf_init
	$(TF_REFRESH)

tf_destroy: tf_init
	cd $(AWS_ENV_DIR)/$(RESOURCE); \
	$(TF_DESTROY)



.PHONY: init setup_env check_aws_profile tf_apply tf_plan tf_init tf_remote_state tf_refresh tf_plan tf_destroy

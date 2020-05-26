#!/usr/bin/env bash
#
set -x

# Get scripts dir path
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# AWS profile
AWS_PROFILE=${AWS_PROFILE:-default}
ENV=${ENV:-root}

# Read AWS default region from $HOME/.aws/config using the default profile
AWS_REGION=$($DIR/read_cfg.sh $HOME/.aws/config "profile ${AWS_PROFILE}" region)



if [ "${ENV}" == "root" ];then
	AWS_ACCOUNTS=$(aws organizations list-accounts \
				--query 'Accounts[].[Name,Id]' \
				| jq -c '.[]')
	

	for ROW in "${AWS_ACCOUNTS}"; do
		NAME=$(echo $ROW | jq -r '.[0]')
		ID=$(echo $ROW | jq -r '.[1]')
		ACCOUNTS+="${NAME} = \"${ID}\"\n\t\t"
	done

	echo -e "
variable \"aws_accounts\" {
	default = {
		${ACCOUNTS}
	}
}" > variables.tf

else
	ACCOUNT_ID=$(aws organizations list-accounts \
				--query 'Accounts[?Name==`'"${ENV}"'`].[Id]' \
				--output text)

	cat > variables.tf <<EOF

variable "aws_region" {
	default = "${AWS_REGION}"
}

variable "account_id" {
	default = "${ACCOUNT_ID}"
}

variable "environment" {
	default = "${ENV}"
}

variable "aws_resource" {
	default = "${RESOURCE}"
}

variable "root_dir" {
	default = "${ROOT_DIR}"
}

EOF
fi

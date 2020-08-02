SHELL = /usr/bin/env bash -xeuo pipefail

stack_name:=ffxiv-item-name-database-resources

describe:
	poetry run aws cloudformation describe-stacks \
		--stack-name $(stack_name) \
		--query Stacks[0].Outputs

deploy:
	poetry run sam deploy \
		--stack-name $(stack_name) \
		--template-file template.yml \
		--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
		--role-arn $CLOUDFORMATION_IAM_ROLE_ARN \
		--no-fail-on-empty-changeset
	poetry run aws cloudformation describe-stacks \
		--stack-name $(stack_name) \
		--query Stacks[0].Outputs

destroy:
	poetry run aws cloudformation delete-stack --stack-name $(stack_name)
	poetry run aws cloudformation wait stack-delete-complete --stack-name $(stack_name)

.PHONY: \
	describe \
	deploy \
	destroy 

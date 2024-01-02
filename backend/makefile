# ifeq ($(ENV), prd)
# 	PROFILE := dev_ono_prd
# 	STACK_NAME := dev-ono-stack-prd
# 	BUCKET_NAME := dev-ono-bucket-prd
# 	TEMPLATE := template_prd.yaml
# 	TEMPLATE_OUT := template_prd_output.yaml
# 	LAYER_DIR := aws-conference-layer-prd
# else ifeq ($(ENV), stg)
	PROFILE := 592113700197_AdministratorAccess
	STACK_NAME := dev-yuki-stack-$(LAYER)-Layer
	BUCKET_NAME := dev-yuki-bucket-test
	TEMPLATE := $(LAYER)_Layer.yaml
	TEMPLATE_OUT := $(LAYER)_Layer_output.yaml
# endif

check:
	@echo Profile: $(PROFILE)
	@echo Stack Name: $(STACK_NAME)
	@echo Bucket Name: $(BUCKET_NAME)
	@echo Template File: $(TEMPLATE)
	@echo Template Output File: $(TEMPLATE_OUT)
	@echo "Are you sure to deploy with these settings? [y/N] " && read ans && [ $${ans:-N} = y ]

make_bucket:
	aws s3 mb s3://${BUCKET_NAME} --region ap-northeast-1 --profile ${PROFILE}

shell:
	sh ./layer.sh

encrypt_bucket:
	aws s3api put-bucket-encryption --bucket ${BUCKET_NAME} --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'  --region ap-northeast-1 --profile ${PROFILE}

bucket:	make_bucket encrypt_bucket

get_cert:
	aws s3 --profile ${PROFILE} cp s3://${BUCKET_NAME}/certs/ ./src/layer/certs/ --recursive

del_cert:
	rm -rf ./src/layer/certs/

pac:
	aws cloudformation package \
	--template ./Layer/${TEMPLATE} \
	--output-template-file ${TEMPLATE_OUT} \
	--s3-bucket ${BUCKET_NAME} --profile ${PROFILE} \
	--region ap-northeast-1

deploy:
	aws cloudformation deploy \
	--template-file ${TEMPLATE_OUT} \
	--stack-name  ${STACK_NAME} \
	--capabilities CAPABILITY_NAMED_IAM --profile ${PROFILE} \
	--region ap-northeast-1

change:
		aws cloudformation create-change-set \
		--stack-name  ${STACK_NAME} \
		--change-set-name test \
		--template-body file://${TEMPLATE_OUT} \
		--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
		--profile ${PROFILE} \
		--region ap-northeast-1

describe:
		aws cloudformation describe-change-set \
		--stack-name ${STACK_NAME} \
		--change-set-name test \
		--profile ${PROFILE} \
		--region ap-northeast-1

events:
		aws cloudformation describe-stack-events \
		--stack-name ${STACK_NAME} \
		--profile ${PROFILE} \
		--region ap-northeast-1

delete:
	@echo "Are you sure to delete the stack ${STACK_NAME}? [y/N] " && read ans && [ $${ans:-N} = y ]
	aws cloudformation delete-stack --stack-name ${STACK_NAME} --profile ${PROFILE} --region ap-northeast-1

all: check get_cert pac deploy del_cert

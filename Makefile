GCP_PROJECT_ID=
KMS_KEY_RING_NAME=
KMS_LINE_SECRETS_KEY_NAME=

KMSKEYFLAGS=--plaintext-file=secrets.json --ciphertext-file=secrets.json.enc --location=global --keyring=$(KMS_KEY_RING_NAME) --key=$(KMS_LINE_SECRETS_KEY_NAME)
init:
	@cp secrets.template.json secrets.json

deploy:
	@gcloud functions deploy gcf-line-bot-sample --trigger-http --runtime=go111
deploy-all:
	@gcloud functions deploy gcf-line-bot-sample \
		--memory=256MB \
		--runtime=go111 \
		--trigger-http \
		--entry-point=Webhook \
		--set-env-vars="GCP_PROJECT_ID"="$(GCP_PROJECT_ID)","KMS_KEY_RING_NAME"="$(KMS_KEY_RING_NAME)","KMS_LINE_SECRETS_KEY_NAME"="$(KMS_LINE_SECRETS_KEY_NAME)"

decrypt-secrets:
	@gcloud kms decrypt $(KMSKEYFLAGS)
encrypt-secrets:
	@gcloud kms encrypt $(KMSKEYFLAGS)

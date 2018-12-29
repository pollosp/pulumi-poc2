PROJECT_DIRECTORY ?= "pulumi-poc2"
STACK ?= "pulumi-poc2-dev"
CONTAINER_GCP_NAME = "pulumi:gcp"
PULUMI_USER ?= "pollosp"
STACK_TYPE ?= "gcp-go"

#Init is for doc propouse, it is only need once when you are creating the project
int-network:
	docker network create example
init-api:
	docker run --rm -d -p 8080:8080 --net example --name api gin-test
build-gcp:
	docker build . -t $(CONTAINER_GCP_NAME)
pulumi-update:
	docker run --rm --net example -ti -e PULUMI_ACCESS_TOKEN="$$PULUMI_ACCESS_TOKEN" -e GREETING="$$GREETING" -e GOOGLE_PROJECT="$$GOOGLE_PROJECT" -e GOOGLE_CREDENTIALS="$$CREDENTIALS" $(CONTAINER_GCP_NAME) update -s $(STACK)
pulumi-preview:
	docker run --rm --net example -ti -e PULUMI_ACCESS_TOKEN="$$PULUMI_ACCESS_TOKEN" -e GREETING="$$GREETING" -e GOOGLE_PROJECT="$$GOOGLE_PROJECT" -e GOOGLE_CREDENTIALS="$$CREDENTIALS"  $(CONTAINER_GCP_NAME) preview -s $(STACK)
pulumi-destroy:
	docker run --rm --net example -ti -e PULUMI_ACCESS_TOKEN="$$PULUMI_ACCESS_TOKEN" -e GREETING="$$GREETING" -e GOOGLE_PROJECT="$$GOOGLE_PROJECT" -e GOOGLE_CREDENTIALS="$$CREDENTIALS" $(CONTAINER_GCP_NAME) destroy -s $(STACK)
	docker network rm example
pulumi-rm-stack:
	docker run --rm --net example -ti -e PULUMI_ACCESS_TOKEN="$$PULUMI_ACCESS_TOKEN" -e GREETING="$$GREETING" -e GOOGLE_PROJECT="$$GOOGLE_PROJECT" -e GOOGLE_CREDENTIALS="$$CREDENTIALS" $(CONTAINER_GCP_NAME) stack rm $(STACK)
pulumi-new-stack:
	docker run --rm -ti -e PULUMI_ACCESS_TOKEN="$$PULUMI_ACCESS_TOKEN" -e GREETING="$$GREETING" -e GOOGLE_PROJECT="$$GOOGLE_PROJECT" -e GOOGLE_CREDENTIALS="$$CREDENTIALS" $(CONTAINER_GCP_NAME) new gcp-go -s $(PULUMI_USER)/$(STACK)
#Due a bug using ENV vars described in https://github.com/pulumi/pulumi-gcp/issues/25 for 0.15.1
config:
	docker run -ti -e PULUMI_ACCESS_TOKEN="$$PULUMI_ACCESS_TOKEN"-v $$PWD:/app  -e GOOGLE_CREDENTIALS="$$CREDENTIALS" pulumi:gcp config set gcp:project

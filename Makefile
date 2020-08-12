SHELL := /bin/bash

wrapper:
	gradle wrapper

dependencies:
	./gradlew dependencies

clean:
	./gradlew clean

compile: clean
	./gradlew build buildZip

.ONESHELL:
tf-init:
	cd tf && \
	terraform init -backend-config="./backend_config/$T_ENV.tfvars"

.ONESHELL:
tf-plan:
	cd tf && \
	terraform plan -var-file "./env_vars/$T_ENV.tfvars" --out ./build.plan

.ONESHELL:
tf-apply:
	cd tf && \
	terraform apply ./build.plan
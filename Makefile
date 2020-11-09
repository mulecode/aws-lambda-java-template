SHELL := /bin/bash
ENV ?= dev

wrapper:
	gradle wrapper

dependencies:
	./gradlew dependencies

clean:
	./gradlew clean

compile: clean
	./gradlew build -x test buildZip

test:
	./gradlew test

.ONESHELL:
tf-init:
	cd tf && \
	terraform init -backend-config="./backend_config/$(ENV).tfvars"

.ONESHELL:
tf-plan:
	cd tf && \
	terraform plan -var-file "./env_vars/$(ENV).tfvars" --out ./build.plan

.ONESHELL:
tf-apply:
	cd tf && \
	terraform apply ./build.plan
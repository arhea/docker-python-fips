AWS_PROFILE=personal
CONTAINER_NAME=python-fips

.PHONY: trigger trigger-27 trigger-37 trigger-38 build build-27 build-37 build-38

trigger: trigger-27 trigger-37 trigger-38

trigger-27:
	aws codebuild start-build --project-name="DockerPythonFips" --environment-variables-override="IMAGE_TAG=2.7,PYTHON_VERSION=2.7.17" --profile $(AWS_PROFILE)

trigger-37:
	aws codebuild start-build --project-name="DockerPythonFips" --environment-variables-override="IMAGE_TAG=3.7,PYTHON_VERSION=3.7.5" --profile $(AWS_PROFILE)

trigger-38:
	aws codebuild start-build --project-name="DockerPythonFips" --environment-variables-override="IMAGE_TAG=3.8,PYTHON_VERSION=3.8.0" --profile $(AWS_PROFILE)

build: build-27 build-37 build-38

build-27:
	docker build --tag $(CONTAINER_NAME):2.7 --build-arg PYTHON_VERSION=2.7.17 .

build-37:
	docker build --tag $(CONTAINER_NAME):3.7 --build-arg PYTHON_VERSION=3.7.5 .

build-38:
	docker build --tag $(CONTAINER_NAME):3.8 --build-arg PYTHON_VERSION=3.8.0 .

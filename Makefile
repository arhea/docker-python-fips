AWS_PROFILE=personal
CONTAINER_NAME=python-fips

.PHONY: trigger trigger-27 trigger-37 trigger-38 build build-27 build-37 build-38

trigger: trigger-27 trigger-37 trigger-38

trigger-27:
	aws codebuild start-build \
		--project-name="DockerPythonFips" \
		--environment-variables-override="name=IMAGE_TAG,value=2.7,type=PLAINTEXT,name=PYTHON_VERSION,value=2.7.17,type=PLAINTEXT" \
		--profile $(AWS_PROFILE)

trigger-37:
	aws codebuild start-build \
		--project-name="DockerPythonFips" \
		--environment-variables-override="name=IMAGE_TAG,value=3.7,type=PLAINTEXT,name=PYTHON_VERSION,value=3.7.5,type=PLAINTEXT" \
		--profile $(AWS_PROFILE)

trigger-38:
	aws codebuild start-build \
		--project-name="DockerPythonFips" \
		--environment-variables-override="name=IMAGE_TAG,value=3.8,type=PLAINTEXT,name=PYTHON_VERSION,value=3.8.0,type=PLAINTEXT" \
		--profile $(AWS_PROFILE)

build: build-27 build-37 build-38

build-27:
	docker build --tag $(CONTAINER_NAME):2.7 --build-arg PYTHON_VERSION=2.7.17 .

build-37:
	docker build --tag $(CONTAINER_NAME):3.7 --build-arg PYTHON_VERSION=3.7.5 .

build-38:
	docker build --tag $(CONTAINER_NAME):3.8 --build-arg PYTHON_VERSION=3.8.0 .

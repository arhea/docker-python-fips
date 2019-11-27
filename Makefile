CONTAINER_NAME=docker-python-fips

.PHONY: build build-27 build-37 build-38

build: build-27 build-37 build-38

build-27:
	docker build --tag $(CONTAINER_NAME):2.7 --build-arg PYTHON_VERSION=2.7.17 .

build-37:
	docker build --tag $(CONTAINER_NAME):3.7 --build-arg PYTHON_VERSION=3.7.5 .

build-38:
	docker build --tag $(CONTAINER_NAME):3.8 --build-arg PYTHON_VERSION=3.8.0 .

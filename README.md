# Python and OpenSSL with FIPS

![Build Badge](https://codebuild.us-east-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiTmFsaC9XYUJacU83d0J1aVpiVnpCMkU1aHBtbWFOWWN1TUVSczEwbGN2TWNzV2FYNHIzakNwbHZzYS9xazMxREpGZFhuaTRreHdqMDRLN1k4RDJwejEwPSIsIml2UGFyYW1ldGVyU3BlYyI6InNHcjU1eGJBQXIyeDF1YkkiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)

This is an example of how to build OpenSSL with the FIPS module enabled. That latest versions of OpenSSL and the FIPS module can be found on the [OpenSSL website](https://www.openssl.org/source/).

## Usage

This example is wrapped in a Docker container running Ubuntu 16.04. To build the container run the following command:

```bash
make build # will build all of the images
make build-27 # will build python-fips:2.7
make build-37 # will build python-fips:3.7
make build-38 # will build python-fips:3.8
```

Then to run the container:

```bash
docker run -it --rm python-fips:3.8 bash
```

To trigger the builds in CodeBuild:

```bash
make trigger
```

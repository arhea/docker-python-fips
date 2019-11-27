# Python and OpenSSL with FIPS

This is an example of how to build OpenSSL with the FIPS module enabled. That latest versions of OpenSSL and the FIPS module can be found on the [OpenSSL website](https://www.openssl.org/source/).

## Usage

This example is wrapped in a Docker container running Ubuntu 16.04. To build the container run the following command:

```bash
docker build -t docker-python-fips .
```

#!/usr/bin/env python3

import sys
import ssl
import ctypes


libcrypto = ctypes.CDLL("libcrypto.so.1.0.0")

fips_mode = libcrypto.FIPS_mode
fips_mode.argtypes = []
fips_mode.restype = ctypes.c_int

fips_mode_set = libcrypto.FIPS_mode_set
fips_mode_set.argtypes = [ctypes.c_int]
fips_mode_set.restype = ctypes.c_int

text = b""

if __name__ == "__main__":
    print("Python {:s} on {:s}\n".format(sys.version, sys.platform))
    print("OPENSSL_VERSION: {:s}".format(ssl.OPENSSL_VERSION))
    enable_fips = len(sys.argv) > 1

    print("FIPS_mode(): {:d}".format(fips_mode()))
    if enable_fips:
        print("FIPS_mode_set(1): {:d}".format(fips_mode_set(1)))
    print("FIPS_mode(): {:d}".format(fips_mode()))

    import hashlib
    print("SHA1: {:s}".format(hashlib.sha1(text).hexdigest()))
    print("MD5: {:s}".format(hashlib.md5(text).hexdigest()))

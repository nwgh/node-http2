#!/bin/bash

set -ex

NODE_HTTP2_ROOT="$(pwd)"
export NODE_HTTP2_ROOT

MOZ_NODE_PATH="$(which node)"
export MOZ_NODE_PATH

cd firefox-tests
./mach --help
#./mach xpcshell-test xpcshell/tests/netwerk/test/unit/test_http2.js
exit $?

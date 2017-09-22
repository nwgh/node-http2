#!/bin/bash

set -ex

NODE_HTTP2_ROOT="$(pwd)"
export NODE_HTTP2_ROOT

MOZ_NODE_PATH="$(which node)"
export MOZ_NODE_PATH

PATH="${PATH}:${HOME}/bin"
export PATH

cd firefox-tests
TEST_ROOT="$(pwd)"
source "${TEST_ROOT}/build/venv/bin/activate"
mach xpcshell-test xpcshell/tests/netwerk/test/unit/test_http2.js
exit $?

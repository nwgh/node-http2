#!/bin/bash

set -ex

pwd
ls

cd firefox-tests
./mach --help
#./mach xpcshell-test xpcshell/tests/netwerk/test/unit/test_http2.js
exit $?

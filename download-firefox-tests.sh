#!/bin/bash

set -ex

OS="$(uname -s)"
FX_PLATFORM="linux-x86_64"
case "$OS" in
    "Linux")
        # Just take this for granted that this is what we're using now
        ;;
    *)
        echo "Unknown test platform."
        exit 1
        ;;
esac

FX_VERSION="$(curl https://hg.mozilla.org/mozilla-central/raw-file/tip/browser/config/version.txt)"
TEST_PACKAGES="https://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/firefox-${FX_VERSION}.en-US.${FX_PLATFORM}.test_packages.json"
INSTALLER="https://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/firefox-${FX_VERSION}.en-US.${FX_PLATFORM}.tar.bz2"

mkdir firefox-tests

curl -o mozharness.zip https://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/mozharness.zip
unzip -q -u -d firefox-tests mozharness.zip

cd firefox-tests
TEST_ROOT="$(pwd)"

# Let mozharness do most of the work for us, since it'll set stuff up right
"${TEST_ROOT}/mozharness/scripts/desktop_unittest.py" --config-file "${TEST_ROOT}/mozharness/configs/unittests/linux_unittest.py" --config-file "${TEST_ROOT}/mozharness/configs/remove_executables.py" --no-read-buildbot-config --installer-url="${INSTALLER}" --test-packages-url="${TEST_PACKAGES}" --xpcshell-suite=xpcshell --total-chunk=1 --this-chunk=1 --download-symbols=ondemand --no-run-tests

# Now a bit more setup for goodness/ease of use
mkdir "${HOME}/bin"
ln -s "${TEST_ROOT}/build/tests/mach" "${HOME}/bin"
ln "${TEST_ROOT}/build/venv/bin/python" "${TEST_ROOT}/build/venv/bin/python2.7"

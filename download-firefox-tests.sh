#!/bin/bash

set -ex

OS="$(uname -s)"
FX_PLATFORM=""
case "$OS" in
    "Darwin")
        FX_PLATFORM="mac"
        ;;
    "Linux")
        # TODO - figure out cpu type here, too
        FX_PLATFORM="linux-x86_64"
        ;;
    *)
        echo "Unknown test platform."
        exit 1
        ;;
esac

FX_VERSION="$(curl https://hg.mozilla.org/mozilla-central/raw-file/tip/browser/config/version.txt)"
TEST_INFO="$(curl https://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/firefox-${FX_VERSION}.en-US.${FX_PLATFORM}.test_packages.json)"
TEST_FILES_COUNT="$(echo $TEST_INFO | jq '.xpcshell | length')"
mkdir firefox-tests
for i in $(seq 0 $(($TEST_FILES_COUNT - 1))) ; do
    TEST_FILE="$(echo $TEST_INFO | jq -r ".xpcshell[$i]")"
    curl -o "$TEST_FILE" "https://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/${TEST_FILE}"
    unzip -u -d firefox-tests "$TEST_FILE"
done

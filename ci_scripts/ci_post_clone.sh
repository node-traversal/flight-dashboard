#!/bin/sh

set -e

if [[ -z "$FLIGHT_AWARE_API_KEY_SECRET" ]]; then
    echo "Must provide FLIGHT_AWARE_API_KEY_SECRET in environment" 1>&2
    exit 1
fi

if [[ -z "$CI_WORKSPACE" ]]; then
    echo "Must provide CI_WORKSPACE in environment" 1>&2
    exit 1
fi

echo "FLIGHT_AWARE_API_KEY = ${FLIGHT_AWARE_API_KEY_SECRET}" > "${CI_WORKSPACE}/Environment.xcconfig"
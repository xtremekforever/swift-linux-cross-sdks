#!/bin/bash

set -e

SDK_GENERATOR_BRANCH=${SDK_GENERATOR_BRANCH:=develop}
SDK_GENERATOR_REPO=${SDK_GENERATOR_REPO:=https://github.com/xtremekforever/swift-sdk-generator.git }
SDK_GENERATOR_DIR=${SDK_GENERATOR_DIR:=swift-sdk-generator}

# Checkout
git force-clone -b $SDK_GENERATOR_BRANCH $SDK_GENERATOR_REPO $SDK_GENERATOR_DIR || true
cd $SDK_GENERATOR_DIR

# Build
swift build -c release --static-swift-stdlib

# Test
./.build/release/swift-sdk-generator --help

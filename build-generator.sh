#!/bin/bash

set -e

SDK_GENERATOR_DIR=swift-sdk-generator

# This should default to develop, which has the latest advances in the generator
if [ -d $SDK_GENERATOR_DIR ]; then
    cd $SDK_GENERATOR_DIR
    git pull origin
else
    git clone https://github.com/xtremekforever/swift-sdk-generator.git
    cd $SDK_GENERATOR_DIR
fi

# Build
swift build -c release

# Test
swift-sdk-generator/.build/release/swift-sdk-generator --help

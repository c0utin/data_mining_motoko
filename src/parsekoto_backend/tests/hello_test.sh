#!/bin/bash

# ANSI color codes for green and red
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test the greet function
RESPONSE=$(dfx canister call parsekoto_backend greet '("ICP")')

# Verify the result
EXPECTED='"Hello, ICP!"'
if [[ "$RESPONSE" == *"$EXPECTED"* ]]; then
    echo -e "${GREEN}Test passed: $RESPONSE${NC}"
else
    echo -e "${RED}Test failed: Expected $EXPECTED but got $RESPONSE${NC}"
    exit 1
fi


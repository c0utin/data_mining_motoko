#!/bin/bash

# ANSI color codes for green and red
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# -------DM_CORE TESTS --------------

# Test the canister heart beat function
RESPONSE=$(dfx canister call dm_core heart_beat '("ICP")')

EXPECTED='"Hello, ICP!"'
if [[ "$RESPONSE" == *"$EXPECTED"* ]]; then
    echo -e "${GREEN}Test passed: $RESPONSE${NC}"
else
    echo -e "${RED}Test failed: Expected $EXPECTED but got $RESPONSE${NC}"
    exit 1
fi

# Test calculateDistance function
RESPONSE=$(dfx canister call dm_core calculateDistance '(record { studytime = 10; higher = "Yes"; absences = 2; failures = "No" }, record { studytime = 15; higher = "No"; absences = 5; failures = "Yes" })')
EXPECTED='8'
if [[ "$RESPONSE" == *"$EXPECTED"* ]]; then
    echo -e "${GREEN}Test passed: calculateDistance${NC}"
else
    echo -e "${RED}Test failed: calculateDistance${NC}"
    exit 1
fi


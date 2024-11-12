#!/usr/bin/env bash

echo "Using Bash version: $BASH_VERSION"

# Source the LogIt library
source ./logit.sh

# Color and formatting settings
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
BOLD="\033[1m"
RESET="\033[0m"

# Function to output colored pass/fail messages
function pass_message {
    echo -e "${GREEN}${BOLD}PASS:${RESET} $1"
}

function fail_message {
    echo -e "${RED}${BOLD}FAIL:${RESET} $1"
}

# Function to output section headers
function section_header {
    echo -e "\n${BLUE}${BOLD}==== $1 ====${RESET}\n"
}

# Dividers for clarity
function divider {
    echo -e "${YELLOW}----------------------------------------${RESET}"
}

# Start the tests
section_header "Running LogIt Tests"

# Initialize test channels with custom formats
section_header "Setting Up Channels"
init_channel "test_console" LOG_LEVEL="INFO" LOG_OUTPUT="console" LOG_JSON=false LOG_FORMAT="[LEVEL] [TIMESTAMP]: MESSAGE"
init_channel "test_file" LOG_LEVEL="DEBUG" LOG_OUTPUT="file" LOG_FILE="test_output.log" LOG_JSON=false LOG_FORMAT="CHANNEL: [LEVEL] MESSAGE at TIMESTAMP"

# Remove previous test log file if it exists
rm -f test_output.log

divider

# Function to check log output in test file
function check_log_file {
    local expected_message="$1"
    # Escape square brackets in the expected message for grep
    expected_message=$(echo "$expected_message" | sed 's/\[/\\[/g; s/\]/\\]/g')
    if grep "$expected_message" test_output.log; then
        pass_message "'$expected_message' found in test_output.log"
    else
        fail_message "'$expected_message' NOT found in test_output.log"
    fi
}

# Test log levels
section_header "Testing Log Levels"
log_info "This is an INFO message"
log_debug "This is a DEBUG message"
log_warning "This is a WARNING message"
log_error "This is an ERROR message"

# Check for expected output in console and file
echo -e "\n${BOLD}Checking test_output.log for expected log messages...${RESET}"
divider
check_log_file "test_file: [INFO] This is an INFO message at"
check_log_file "test_file: [DEBUG] This is a DEBUG message at"
check_log_file "test_file: [WARNING] This is a WARNING message at"
check_log_file "test_file: [ERROR] This is an ERROR message at"

divider

# Test JSON output
section_header "Testing JSON Format"
init_channel "json_test" LOG_LEVEL="INFO" LOG_OUTPUT="file" LOG_FILE="test_json_output.log" LOG_JSON=true

# Remove previous JSON log file if it exists
rm -f test_json_output.log

log_info "Testing JSON format logging"
log_warning "Warning message in JSON format"
log_error "Error message in JSON format"

# Verify JSON format in file
echo -e "\n${BOLD}Checking test_json_output.log for JSON formatted messages...${RESET}"
divider
if grep -q '"message": "Testing JSON format logging"' test_json_output.log; then
    pass_message "JSON formatted INFO log found in test_json_output.log"
else
    fail_message "JSON formatted INFO log NOT found in test_json_output.log"
fi

if grep -q '"message": "Warning message in JSON format"' test_json_output.log; then
    pass_message "JSON formatted WARNING log found in test_json_output.log"
else
    fail_message "JSON formatted WARNING log NOT found in test_json_output.log"
fi

if grep -q '"message": "Error message in JSON format"' test_json_output.log; then
    pass_message "JSON formatted ERROR log found in test_json_output.log"
else
    fail_message "JSON formatted ERROR log NOT found in test_json_output.log"
fi

# Cleanup test files
section_header "Cleaning Up"
#rm -f test_output.log test_json_output.log

section_header "LogIt Tests Completed"

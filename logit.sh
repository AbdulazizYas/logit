#!/usr/bin/env bash

# LogIt Version
LOGIT_VERSION="1.0.0"

# Default color settings for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RESET="\033[0m"
BOLD="\033[1m"

# Configuration variables using associative arrays
declare -A channels

# Default configuration values for any channel
DEFAULT_LOG_LEVEL="INFO"
DEFAULT_LOG_OUTPUT="console"
DEFAULT_LOG_FILE="/var/log/default.log"
DEFAULT_LOG_JSON=false
DEFAULT_LOG_FORMAT="[TIMESTAMP] [LEVEL] [CHANNEL]: MESSAGE"

# Function to get log level integer for comparison
function _get_log_level_value {
    case "$1" in
        DEBUG) echo 0 ;;
        INFO) echo 1 ;;
        SUCCESS) echo 2 ;;
        WARNING) echo 3 ;;
        ERROR) echo 4 ;;
        *) echo 1 ;; # Default to INFO level
    esac
}

# Function to format timestamp
function _timestamp {
    date +"%Y-%m-%d %H:%M:%S"
}

# Initialize a logging channel with parameters and defaults
function init_channel {
    local name="$1"
    shift

    # Initialize an associative array for channel configuration
    declare -A config=(
        ["LOG_LEVEL"]="$DEFAULT_LOG_LEVEL"
        ["LOG_OUTPUT"]="$DEFAULT_LOG_OUTPUT"
        ["LOG_FILE"]="$DEFAULT_LOG_FILE"
        ["LOG_JSON"]="$DEFAULT_LOG_JSON"
        ["LOG_FORMAT"]="$DEFAULT_LOG_FORMAT"
    )

    # Parse additional arguments to override defaults
    for arg in "$@"; do
        case $arg in
            LOG_LEVEL=*) config["LOG_LEVEL"]="${arg#*=}" ;;
            LOG_OUTPUT=*) config["LOG_OUTPUT"]="${arg#*=}" ;;
            LOG_FILE=*) config["LOG_FILE"]="${arg#*=}" ;;
            LOG_JSON=*) config["LOG_JSON"]="${arg#*=}" ;;
            LOG_FORMAT=*) config["LOG_FORMAT"]="${arg#*=}" ;;
            *) echo "Unknown parameter for channel $name: $arg" ;;
        esac
    done

    # Store the channel configuration in the main channels associative array
    channels["$name"]="$(declare -p config)"
}

# Function to apply custom format to log messages
function _apply_format {
    local format="$1"
    local timestamp="$2"
    local level="$3"
    local channel="$4"
    local message="$5"

    # Replace placeholders with actual values
    local formatted_message="${format//TIMESTAMP/$timestamp}"
    formatted_message="${formatted_message//LEVEL/$level}"
    formatted_message="${formatted_message//CHANNEL/$channel}"
    formatted_message="${formatted_message//MESSAGE/$message}"

    echo "$formatted_message"
}

# Core logging function with support for multiple channels and custom formatting
function _log {
    local level="$1"
    local color="$2"
    local emoji="$3"
    local message="$4"
    
    for channel_name in "${!channels[@]}"; do
        # Retrieve channel-specific configuration
        eval "${channels[$channel_name]}"
        
        local level_value=$(_get_log_level_value "$level")
        local current_level_value=$(_get_log_level_value "${config[LOG_LEVEL]}")

        # Check if message should be logged for this channel based on level
        if (( level_value >= current_level_value )); then
            local timestamp="$(_timestamp)"
            local format="${config[LOG_FORMAT]}"

            # Format the message according to JSON or text format
            if [ "${config[LOG_JSON]}" = true ]; then
                log_message="{\"timestamp\": \"$timestamp\", \"level\": \"$level\", \"channel\": \"$channel_name\", \"message\": \"$message\"}"
            else
                log_message="$(_apply_format "$format" "$timestamp" "$level" "$channel_name" "$message")"
            fi

            # Output message based on LOG_OUTPUT setting
            if [ "${config[LOG_OUTPUT]}" = "file" ]; then
                echo -e "$log_message" >> "${config[LOG_FILE]}"
            else
                echo -e "$log_message" >&2
            fi
        fi
    done
}

# Wrapper functions for each log level
function log_debug { _log "DEBUG" "$YELLOW" "🔍" "$1"; }
function log_info { _log "INFO" "$CYAN" "ℹ️" "$1"; }
function log_success { _log "SUCCESS" "$GREEN" "✅" "$1"; }
function log_warning { _log "WARNING" "$YELLOW" "🟡" "$1"; }
function log_error { _log "ERROR" "$RED" "❌" "$1"; }

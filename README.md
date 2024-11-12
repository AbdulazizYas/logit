# LogIt: A Flexible Logging Library for Bash

**LogIt** is a lightweight, modular logging library for Bash scripts. It provides customizable multi-channel logging with options for log level, output format, destination, and custom formatting.

## Features
- **Multi-channel Support**: Configure multiple logging channels with unique settings.
- **Configurable Log Levels**: Control verbosity per channel.
- **Flexible Output**: Log to console or files, in text or JSON format.
- **Customizable Formatting**: Define your own format for log messages.
- **Standalone File**: Just download `logit.sh` and source it in your scripts—no dependencies!

## Installation

1. **Download `logit.sh`**  
   You can place `logit.sh` in your project’s root folder or specify a different directory.

   - **To download to the root folder**:
     ```bash
     curl -O https://raw.githubusercontent.com/yourusername/LogIt/main/logit.sh
     ```

   - **To download to a specific directory**:
     ```bash
     mkdir -p path/to/your_directory
     curl -o path/to/your_directory/logit.sh https://raw.githubusercontent.com/yourusername/LogIt/main/logit.sh
     ```

2. **Source `logit.sh` in your script**  
   In your script, point to `logit.sh` based on where it’s saved:

   ```bash
   # If `logit.sh` is in the root directory
   source ./logit.sh

   # Or, if it's in a specific directory
   source path/to/your_directory/logit.sh
   ```

## Usage

### Initializing Logging Channels

Set up one or more channels to define where and how messages should be logged. You can specify a custom format for each channel.

```bash
# Initialize a console channel with DEBUG level, plain text, and custom format
init_channel "console" LOG_LEVEL="DEBUG" LOG_OUTPUT="console" LOG_JSON=false LOG_FORMAT="[LEVEL] [TIMESTAMP]: MESSAGE"

# Initialize a file-based channel with INFO level, JSON format, and a different custom format
init_channel "file_log" LOG_LEVEL="INFO" LOG_OUTPUT="file" LOG_FILE="/path/to/logfile.log" LOG_JSON=false LOG_FORMAT="CHANNEL: [LEVEL] MESSAGE at TIMESTAMP"
```

### Logging Messages

Once channels are initialized, use the logging functions below. Each function logs messages according to the configuration of each channel.

```bash
log_info "Starting the script"
log_debug "Debugging information"
log_warning "This is a warning"
log_error "An error occurred"
```

### Example Script

Here’s a complete example that demonstrates how to set up channels, customize formats, and log messages:

```bash
#!/bin/bash

# Source LogIt
source ./logit.sh

# Initialize channels
init_channel "console" LOG_LEVEL="DEBUG" LOG_OUTPUT="console" LOG_JSON=false LOG_FORMAT="[LEVEL] [TIMESTAMP]: MESSAGE"
init_channel "file_log" LOG_LEVEL="INFO" LOG_OUTPUT="file" LOG_FILE="./example_log.json" LOG_JSON=true LOG_FORMAT="CHANNEL: LEVEL - MESSAGE at TIMESTAMP"

# Log various messages
log_info "Script started"
log_debug "Debug information here"
log_success "Operation successful"
log_warning "This might cause issues"
log_error "An error has occurred"

# Check the console and the file "./example_log.json" for output
```

## Configuration Options

You can set each channel independently with these options:

- `LOG_LEVEL`: Sets the minimum level to log (DEBUG, INFO, SUCCESS, WARNING, ERROR).
- `LOG_OUTPUT`: Choose `"console"` or `"file"` for output type.
- `LOG_FILE`: Specify the log file path if using file output.
- `LOG_JSON`: Set to `true` for JSON output, `false` for plain text.
- `LOG_FORMAT`: Define a custom format for log messages. Available placeholders:
  - `TIMESTAMP` - Replaced by the log message’s timestamp.
  - `LEVEL` - Replaced by the log level.
  - `CHANNEL` - Replaced by the channel name.
  - `MESSAGE` - Replaced by the log message.

## Contributing

We welcome contributions to LogIt! If you'd like to contribute, please follow these guidelines:

1. **Fork the repository** and create a new branch for your changes.
2. **Write tests** for any new functionality or bug fixes.
3. **Submit a pull request** with a detailed description of your changes and why they’re beneficial.

For more information, see the [CONTRIBUTING.md](.github/CONTRIBUTING.md) file.

## Issues

If you encounter any issues while using LogIt, please feel free to submit an issue on the [GitHub Issues page](https://github.com/yourusername/LogIt/issues). Include as much information as possible, such as:

- A clear description of the issue.
- Steps to reproduce the issue.
- Any error messages or log output.
  
We’ll work to address issues as quickly as possible!

## Troubleshooting

Here are some common issues and solutions:

1. **LogIt Not Found Error**:  
   Ensure `logit.sh` is downloaded to the correct path and sourced correctly:
   ```bash
   source /path/to/logit.sh
   ```

2. **Logs Not Appearing in Specified Log File**:  
   Double-check that the file path provided in `LOG_FILE` is correct and that you have write permissions. Also, verify that the `LOG_OUTPUT` is set to `"file"`.

3. **Messages Not Logging at Expected Levels**:  
   Check the `LOG_LEVEL` setting for each channel. Ensure that the level specified allows the desired log messages to appear. For instance, if `LOG_LEVEL` is set to `INFO`, `DEBUG` messages will be suppressed.

If you’re still having trouble, feel free to open an issue for assistance.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
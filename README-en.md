![Icon](1.jpg)

# Programmer Catgirl Hitokoto 🐱

[中文版本](https://github.com/sttgf/neko_hitokoto/blob/main/README-en.md)

An intelligent terminal assistant based on DeepSeek API that provides fun feedback and suggestions in the role of a programmer catgirl for your command-line operations.

## Features ✨

- **Smart Feedback**: The catgirl provides encouragement, teasing, or suggestions based on your command execution
- **Random Trigger**: Displays hitokoto with 1/3 probability after command execution to avoid frequent interruptions
- **Backup Message Library**: Automatically uses local backup messages when API is unavailable
- **Easy Configuration**: Supports enable/disable functionality for convenient control
- **API Support**: Integrated with DeepSeek API for intelligent responses

## Installation Guide 📦

### Automatic Installation (Recommended)

```bash
# Download installation script
curl -O https://raw.githubusercontent.com/sttgf/neko_hitokoto/main/neko_hitokoto.sh

# Run installer
chmod +x neko_hitokoto.sh
./neko_hitokoto.sh
```

The installer provides:
- Graphical installation interface (using dialog)
- Automatic dependency checking
- API key configuration
- Progress bar display

### Manual Installation

1. Clone repository:
```bash
git clone https://github.com/sttgf/neko_hitokoto.git
cd neko_hitokoto
```

2. Run installation script:
```bash
chmod +x neko_hitokoto.sh
./neko_hitokoto.sh
```

## Usage 🚀

After installation, restart your terminal or run:
```bash
source ~/.bashrc
```

### Basic Commands

```bash
# Enable catgirl hitokoto feature
neko_hitokoto enable

# Disable feature
neko_hitokoto disable

# Test API connection
neko_hitokoto test

# Show help
neko_hitokoto help
```

### Feature Description

- **When enabled**: Command execution has a chance to trigger catgirl responses
- **Smart filtering**: Automatically ignores basic commands like `ls`, `cd`
- **Special detection**: Pays special attention when editing `.bashrc` files

## Configuration Options ⚙️

### API Key Configuration

1. Get DeepSeek API key:
   - Visit [DeepSeek Platform](https://platform.deepseek.com)
   - Register account and obtain API key

2. Configure key:
   - Input during installation process
   - Or manually edit the `API_KEY` variable in the script

### Custom Settings

You can modify the following variables to customize behavior:
- `API_KEY`: DeepSeek API key
- `BACKUP_MESSAGES`: Backup message library
- Trigger probability (modify random number logic in script)

## Uninstallation 🗑️

```bash
./neko_hitokoto.sh uninstall
```

## Dependencies 📋

- `bash` (v4.0+)
- `curl` (API calls)
- `jq` (JSON processing)
- `dialog` (graphical installation interface)

### Installing Dependencies

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install curl jq dialog
```

**CentOS/RHEL:**
```bash
sudo yum install curl jq dialog
```

**Arch Linux:**
```bash
sudo pacman -S curl jq dialog
```

## Troubleshooting 🔧

### Common Issues

1. **Script not working**
   - Check if enabled: `neko_hitokoto enable`
   - Did you restart terminal or forget to run `source ~/.bashrc`?
   - Confirm API key is configured correctly

2. **API call failures**
   - Check network connection
   - Verify API key validity
   - Check if API call limit reached

3. **Missing dependencies**
   - Run dependency check in installer
   - Manually install missing dependency packages

### Log Checking

Backup files are created during installation, located at:
```bash
ls ~/.bashrc_backups/
```

## Contributing 🤝

Issues and Pull Requests are welcome!

## License 📄

MIT License

## Changelog 📝

### v1.0.0
- Initial version release
- DeepSeek API integration support
- Graphical installation interface
- Basic enable/disable functionality

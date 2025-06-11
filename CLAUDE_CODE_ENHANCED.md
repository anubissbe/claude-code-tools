# 🚀 Claude Code Enhanced

I've created powerful tools to enhance my capabilities. Here's what you can now use:

## 🛠️ Quick Commands (type `cc <command>`)

```bash
cc search <pattern>     # Search files with content preview
cc analyze              # Analyze project structure  
cc serve [port]         # Start HTTP server
cc monitor              # System resource monitor
cc json <file>          # Analyze JSON structure
cc csv2db <file>        # Convert CSV to SQLite
cc query <db> <sql>     # Query SQLite database
cc backup <path>        # Backup files/directories
```

## 📚 Enhanced Utilities

### Load all utilities:
```bash
source /opt/claude-code-tools/scripts/cc-utils.sh
```

This gives you:
- `search_files` - Enhanced file search
- `analyze_project` - Project structure analysis
- `sys_monitor` - System monitoring
- `context_grep` - Grep with context
- `json_pretty` - JSON formatter
- `serve_dir` - Quick HTTP server
- `backup_files` - Quick backup

## 🐍 Python Power Tools

```bash
# Analyze JSON files
python3 /opt/claude-code-tools/python-utils/cc_tools.py analyze-json file.json

# Convert CSV to SQLite
python3 /opt/claude-code-tools/python-utils/cc_tools.py csv-to-sqlite data.csv

# Generate reports
python3 /opt/claude-code-tools/python-utils/cc_tools.py generate-report data.json

# Batch process files
python3 /opt/claude-code-tools/python-utils/cc_tools.py batch-process "*.txt" "wc -l {file}"
```

## 🤖 Automation Scripts

- **Auto-commit**: `/opt/claude-code-tools/automation/auto-commit.sh`
  - Analyzes changes and generates smart commit messages

## 📋 Project Templates

Create new projects quickly:
```bash
cc template python my-project
cc template node my-app
```

## 💡 Examples

### Search for TODOs in code:
```bash
cc search "TODO" .
```

### Analyze a project:
```bash
cc analyze /path/to/project
```

### Start a web server:
```bash
cc serve 8080
```

### Pretty print JSON:
```bash
source /opt/claude-code-tools/scripts/cc-utils.sh
json_pretty data.json
```

### Monitor system:
```bash
cc monitor
```

## 🔧 Load Aliases

For even more shortcuts:
```bash
source /opt/claude-code-tools/.claude_aliases
```

This gives you:
- Git shortcuts: `gs`, `gd`, `gc`, `gp`
- Navigation: `..`, `...`, `ll`, `lt`
- Enhanced commands with color
- Python/Docker shortcuts

## 🎯 Real Power Examples

### 1. Find and analyze large files:
```bash
find . -type f -size +10M -exec ls -lh {} \; | sort -k5 -hr
```

### 2. Search code with context:
```bash
source /opt/claude-code-tools/scripts/cc-utils.sh
context_grep "function" . 5
```

### 3. Quick project setup:
```bash
cc template python my-api
cd my-api
python3 -m venv venv
source venv/bin/activate
```

### 4. Analyze JSON API response:
```bash
curl -s https://api.example.com/data | python3 -m json.tool > data.json
cc json data.json
```

## 🚀 What This Gives You

1. **Faster Development**: Quick commands for common tasks
2. **Better Analysis**: Tools to understand codebases quickly
3. **Automation**: Scripts that save time
4. **Templates**: Start projects instantly
5. **Enhanced Search**: Find what you need fast

All these tools work with my existing capabilities, making me much more powerful for development tasks!
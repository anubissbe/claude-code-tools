# Claude Code Tools

A comprehensive toolkit that enhances Claude Code's capabilities with powerful bash scripts, Python utilities, and automation tools.

## 🚀 Quick Start

```bash
# Use the quick launcher
/opt/claude-code-tools/cc <command>

# Or add to PATH for easier access
export PATH="/opt/claude-code-tools:$PATH"
cc <command>
```

## 📦 Installation

The tools are already installed at `/opt/claude-code-tools/`. To make them more accessible:

```bash
# Add to your .bashrc or .zshrc
echo 'export PATH="/opt/claude-code-tools:$PATH"' >> ~/.bashrc
echo 'source /opt/claude-code-tools/.claude_aliases' >> ~/.bashrc
source ~/.bashrc
```

## 🛠️ Available Tools

### 1. Quick Launcher (`cc`)

The main entry point for all Claude Code tools.

```bash
cc search <pattern> [path]  # Search files with content preview
cc analyze [path]           # Analyze project structure
cc serve [port]             # Start HTTP server
cc monitor                  # System resource monitor
cc json <file>              # Analyze JSON structure
cc csv2db <file>            # Convert CSV to SQLite
cc backup <path>            # Backup files/directories
```

#### Examples:

```bash
# Search for TODO comments
cc search "TODO" .

# Analyze current project
cc analyze

# Start web server on port 3000
cc serve 3000

# Check system resources
cc monitor

# Analyze JSON structure
cc json data.json

# Convert CSV to SQLite database
cc csv2db sales_data.csv

# Backup a directory
cc backup ./important-project
```

### 2. Bash Utilities (`cc-utils.sh`)

Enhanced bash functions for common development tasks.

```bash
# Load the utilities
source /opt/claude-code-tools/scripts/cc-utils.sh
```

#### Available Functions:

- **`search_files <pattern> [path]`** - Search with content preview
- **`analyze_project [path]`** - Comprehensive project analysis
- **`query_db <database> <query>`** - SQLite query helper
- **`json_pretty <file>`** - Pretty print JSON
- **`serve_dir [port]`** - Python HTTP server
- **`sys_monitor`** - System resource monitor
- **`context_grep <pattern> [path] [lines]`** - Grep with context
- **`backup_files <source>`** - Timestamped backups
- **`create_from_template <type> <name>`** - Project templates

#### Examples:

```bash
# Load utilities
source /opt/claude-code-tools/scripts/cc-utils.sh

# Search with preview
search_files "class.*User" ./src

# Analyze project structure
analyze_project ~/my-project

# Query SQLite database
query_db ./app.db "SELECT * FROM users LIMIT 5"

# Pretty print JSON
json_pretty response.json

# Grep with 5 lines of context
context_grep "error" ./logs 5

# Create Python project from template
create_from_template python my-api
```

### 3. Python Tools (`cc_tools.py`)

Advanced Python utilities for data processing and analysis.

```bash
python3 /opt/claude-code-tools/python-utils/cc_tools.py <command> [args]
```

#### Commands:

- **`analyze-json <file>`** - Analyze JSON file structure
- **`csv-to-sqlite <file>`** - Convert CSV to SQLite database
- **`generate-report <file>`** - Generate markdown reports
- **`batch-process`** - Process multiple files

#### Examples:

```bash
# Analyze complex JSON
python3 /opt/claude-code-tools/python-utils/cc_tools.py analyze-json api_response.json

# Convert CSV to queryable database
python3 /opt/claude-code-tools/python-utils/cc_tools.py csv-to-sqlite sales_2024.csv

# Generate report from data
python3 /opt/claude-code-tools/python-utils/cc_tools.py generate-report data.json --format markdown

# Batch process files
python3 /opt/claude-code-tools/python-utils/cc_tools.py batch-process \
  --pattern "*.log" \
  --command "grep ERROR {file} | wc -l"
```

### 4. Automation Scripts

Located in `/opt/claude-code-tools/automation/`

#### auto-commit.sh

Intelligent git commit message generator.

```bash
# Stage your changes first
git add .

# Generate and create commit
/opt/claude-code-tools/automation/auto-commit.sh
```

Features:
- Analyzes staged changes
- Generates descriptive commit messages
- Lists all modified files
- Categorizes changes (Add/Update/Remove)

### 5. Project Templates

Pre-configured project structures for quick starts.

#### Python Project Template

```bash
cc template python my-project
cd my-project
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Includes:
- `setup.py` for package configuration
- `requirements.txt` with common dependencies
- `.gitignore` with Python-specific patterns

#### Node.js Project Template

```bash
cc template node my-app
cd my-app
npm install
npm run dev
```

Includes:
- `package.json` with scripts
- Development dependencies (Jest, Nodemon)
- Basic project structure

### 6. Aliases

Load helpful aliases:

```bash
source /opt/claude-code-tools/.claude_aliases
```

Provides shortcuts for:
- **Git**: `gs` (status), `gd` (diff), `gc` (commit), `gp` (push)
- **Navigation**: `..`, `...`, `ll`, `lt`
- **Python**: `py`, `pip`, `venv`, `activate`
- **Docker**: `dps`, `dimg`, `dexec`
- **System**: `ports`, `process`

## 📊 Databases

Pre-configured SQLite databases in `/opt/claude-code-tools/databases/`:

### tools.db

Contains useful commands and code snippets:

```sql
-- Query useful commands
SELECT * FROM commands WHERE category = 'git';

-- Find code snippets
SELECT * FROM snippets WHERE language = 'python';
```

## 🔧 Advanced Usage

### Combining Tools

```bash
# Analyze JSON API response and convert to database
curl -s https://api.example.com/data | tee response.json
cc json response.json
python3 /opt/claude-code-tools/python-utils/cc_tools.py generate-report response.json

# Search project and create report
cc analyze ./src > project_analysis.md
cc search "TODO\|FIXME" . >> project_analysis.md
```

### Custom Workflows

```bash
# Development workflow
source /opt/claude-code-tools/scripts/cc-utils.sh
analyze_project
search_files "test" ./tests
serve_dir 8080

# Data processing workflow
cc csv2db data.csv
query_db data.db "SELECT COUNT(*) FROM data"
python3 /opt/claude-code-tools/python-utils/cc_tools.py generate-report data.db
```

## 🤝 Integration with Claude Code

These tools are designed to enhance Claude Code's built-in capabilities:

1. **File Operations**: Enhanced search and analysis beyond basic Read/Write
2. **Data Processing**: Convert between formats, analyze structures
3. **Automation**: Reduce repetitive tasks
4. **Templates**: Faster project initialization
5. **Monitoring**: Keep track of system resources

## 📝 Notes

- All tools work with Claude Code's existing permissions
- No external dependencies required (except standard Unix tools)
- Data stays local - no external API calls
- Tools can be chained together for complex workflows

## 🐛 Troubleshooting

### Command not found

```bash
# Ensure tools are in PATH
export PATH="/opt/claude-code-tools:$PATH"

# Or use full path
/opt/claude-code-tools/cc <command>
```

### Permission denied

```bash
# Make scripts executable
chmod +x /opt/claude-code-tools/cc
chmod +x /opt/claude-code-tools/scripts/*.sh
chmod +x /opt/claude-code-tools/automation/*.sh
```

### Python module errors

```bash
# Install required Python packages
pip3 install pandas requests pyyaml
```

## 🚀 Examples Gallery

### Project Analysis Report

```bash
# Generate comprehensive project report
cc analyze > report.md
echo "## Code Search Results" >> report.md
cc search "class\|function" . >> report.md
echo "## TODO Items" >> report.md
cc search "TODO\|FIXME" . >> report.md
```

### Data Pipeline

```bash
# Download, analyze, and store data
curl -s https://example.com/data.json -o raw_data.json
cc json raw_data.json
python3 /opt/claude-code-tools/python-utils/cc_tools.py generate-report raw_data.json
```

### Backup Before Major Changes

```bash
# Create timestamped backup
cc backup ./my-project
# Make changes...
# If needed, restore from /opt/claude-code-tools/backups/
```

## 📚 Further Customization

Feel free to:
- Add your own functions to `cc-utils.sh`
- Create new automation scripts
- Extend the Python tools
- Add more project templates
- Create custom aliases

The toolkit is designed to be extensible and adaptable to your workflow!
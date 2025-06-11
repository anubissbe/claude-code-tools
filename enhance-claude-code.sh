#!/bin/bash

# Claude Code Enhancement Setup Script
# This creates tools and utilities that Claude Code can actually use

set -e

echo "=== Claude Code Enhancement Setup ==="
echo "Creating tools and utilities for Claude Code..."

# Create directory structure
mkdir -p /opt/claude-code-tools/{scripts,python-utils,databases,templates,automation}

# 1. Create powerful bash utilities
cat > /opt/claude-code-tools/scripts/cc-utils.sh << 'EOF'
#!/bin/bash
# Claude Code Utilities - Source this file for enhanced functionality

# Enhanced file search with content preview
search_files() {
    local pattern="$1"
    local path="${2:-.}"
    echo "Searching for '$pattern' in $path..."
    rg -l "$pattern" "$path" 2>/dev/null | while read -r file; do
        echo -e "\n📄 $file:"
        rg -C 2 "$pattern" "$file" --color=never | head -10
    done
}

# Quick project analyzer
analyze_project() {
    local path="${1:-.}"
    echo "🔍 Project Analysis for: $path"
    echo "========================"
    
    # Count files by type
    echo -e "\n📊 File Statistics:"
    find "$path" -type f -name "*.*" | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -20
    
    # Show directory structure
    echo -e "\n📁 Directory Structure:"
    tree -L 3 -d "$path" 2>/dev/null || find "$path" -type d | head -20
    
    # Git info if available
    if [ -d "$path/.git" ]; then
        echo -e "\n🔀 Git Information:"
        cd "$path" && git status -s
        echo "Recent commits:"
        git log --oneline -5
    fi
    
    # Look for important files
    echo -e "\n📋 Important Files:"
    for file in README.md package.json requirements.txt Dockerfile docker-compose.yml Makefile; do
        [ -f "$path/$file" ] && echo "✓ $file"
    done
}

# Database query helper
query_db() {
    local db="$1"
    local query="$2"
    sqlite3 "$db" "$query" | column -t -s '|'
}

# JSON pretty printer with jq
json_pretty() {
    local file="$1"
    jq '.' "$file" 2>/dev/null || python3 -m json.tool "$file"
}

# Quick HTTP server
serve_dir() {
    local port="${1:-8000}"
    echo "Starting HTTP server on port $port..."
    python3 -m http.server "$port"
}

# System resource monitor
sys_monitor() {
    echo "🖥️  System Resources:"
    echo "==================="
    echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
    echo "Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
    echo "Disk: $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"
    echo -e "\nTop Processes:"
    ps aux --sort=-%cpu | head -6
}

# Enhanced grep with context
context_grep() {
    local pattern="$1"
    local path="${2:-.}"
    local context="${3:-3}"
    rg -C "$context" "$pattern" "$path" --color=always
}

# Quick backup
backup_files() {
    local source="$1"
    local backup_dir="/opt/claude-code-tools/backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    cp -r "$source" "$backup_dir/"
    echo "✓ Backed up to: $backup_dir"
}

# Template creator
create_from_template() {
    local template="$1"
    local name="$2"
    local template_dir="/opt/claude-code-tools/templates"
    
    case "$template" in
        python)
            cp -r "$template_dir/python-project" "$name"
            echo "✓ Created Python project: $name"
            ;;
        node)
            cp -r "$template_dir/node-project" "$name"
            echo "✓ Created Node.js project: $name"
            ;;
        *)
            echo "Available templates: python, node"
            ;;
    esac
}

# Export all functions
export -f search_files analyze_project query_db json_pretty serve_dir
export -f sys_monitor context_grep backup_files create_from_template

echo "✓ Claude Code utilities loaded!"
EOF

chmod +x /opt/claude-code-tools/scripts/cc-utils.sh

# 2. Create Python utilities
cat > /opt/claude-code-tools/python-utils/cc_tools.py << 'EOF'
#!/usr/bin/env python3
"""
Claude Code Python Tools
Enhanced utilities for Claude Code operations
"""

import json
import sqlite3
import pandas as pd
import requests
from pathlib import Path
import yaml
import csv
import sys
import argparse
from datetime import datetime
import subprocess
import os

class ClaudeCodeTools:
    def __init__(self):
        self.data_dir = Path("/opt/claude-code-tools/databases")
        self.data_dir.mkdir(exist_ok=True)
    
    def analyze_json(self, filepath):
        """Analyze JSON file structure"""
        with open(filepath, 'r') as f:
            data = json.load(f)
        
        def analyze_structure(obj, prefix=""):
            if isinstance(obj, dict):
                print(f"{prefix}Dictionary with {len(obj)} keys:")
                for key in list(obj.keys())[:5]:
                    print(f"{prefix}  - {key}: {type(obj[key]).__name__}")
                    if isinstance(obj[key], (dict, list)):
                        analyze_structure(obj[key], prefix + "    ")
            elif isinstance(obj, list):
                print(f"{prefix}List with {len(obj)} items")
                if obj:
                    print(f"{prefix}  Item type: {type(obj[0]).__name__}")
                    if isinstance(obj[0], (dict, list)):
                        analyze_structure(obj[0], prefix + "    ")
        
        print(f"Analyzing JSON file: {filepath}")
        print("=" * 50)
        analyze_structure(data)
    
    def csv_to_sqlite(self, csv_file, db_name=None, table_name=None):
        """Convert CSV to SQLite database"""
        csv_path = Path(csv_file)
        if not db_name:
            db_name = csv_path.stem + ".db"
        if not table_name:
            table_name = csv_path.stem
        
        db_path = self.data_dir / db_name
        
        # Read CSV
        df = pd.read_csv(csv_file)
        
        # Create SQLite connection
        conn = sqlite3.connect(db_path)
        
        # Write to SQLite
        df.to_sql(table_name, conn, if_exists='replace', index=False)
        
        # Show info
        cursor = conn.cursor()
        cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
        count = cursor.fetchone()[0]
        
        print(f"✓ Created database: {db_path}")
        print(f"✓ Table '{table_name}' with {count} rows")
        print(f"\nColumns: {', '.join(df.columns)}")
        
        conn.close()
        return str(db_path)
    
    def generate_report(self, data_file, output_format="markdown"):
        """Generate reports from data files"""
        path = Path(data_file)
        
        if path.suffix == '.json':
            with open(path) as f:
                data = json.load(f)
        elif path.suffix == '.csv':
            data = pd.read_csv(path).to_dict('records')
        else:
            raise ValueError("Unsupported file format")
        
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
        if output_format == "markdown":
            report = f"# Report: {path.name}\n"
            report += f"Generated: {timestamp}\n\n"
            report += f"## Summary\n"
            report += f"- Total records: {len(data)}\n\n"
            report += f"## Data Preview\n"
            report += "```json\n"
            report += json.dumps(data[:5], indent=2)
            report += "\n```\n"
            
            output_file = path.with_suffix('.md')
            with open(output_file, 'w') as f:
                f.write(report)
            
            print(f"✓ Generated report: {output_file}")
            return str(output_file)
    
    def batch_process(self, pattern, command, directory="."):
        """Batch process files matching pattern"""
        from pathlib import Path
        import subprocess
        
        files = list(Path(directory).glob(pattern))
        results = []
        
        print(f"Found {len(files)} files matching '{pattern}'")
        
        for file in files:
            cmd = command.format(file=file)
            print(f"Processing: {file}")
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            results.append({
                'file': str(file),
                'success': result.returncode == 0,
                'output': result.stdout,
                'error': result.stderr
            })
        
        # Save results
        results_file = self.data_dir / f"batch_results_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(results_file, 'w') as f:
            json.dump(results, f, indent=2)
        
        print(f"\n✓ Processed {len(files)} files")
        print(f"✓ Results saved to: {results_file}")
        
        return results

def main():
    parser = argparse.ArgumentParser(description="Claude Code Python Tools")
    parser.add_argument('command', choices=['analyze-json', 'csv-to-sqlite', 'generate-report', 'batch-process'])
    parser.add_argument('file', nargs='?', help='Input file')
    parser.add_argument('--pattern', help='File pattern for batch processing')
    parser.add_argument('--command', help='Command for batch processing')
    parser.add_argument('--format', default='markdown', help='Output format')
    
    args = parser.parse_args()
    
    tools = ClaudeCodeTools()
    
    if args.command == 'analyze-json' and args.file:
        tools.analyze_json(args.file)
    elif args.command == 'csv-to-sqlite' and args.file:
        tools.csv_to_sqlite(args.file)
    elif args.command == 'generate-report' and args.file:
        tools.generate_report(args.file, args.format)
    elif args.command == 'batch-process' and args.pattern and args.command:
        tools.batch_process(args.pattern, args.command)
    else:
        parser.print_help()

if __name__ == '__main__':
    main()
EOF

chmod +x /opt/claude-code-tools/python-utils/cc_tools.py

# 3. Create automation scripts
cat > /opt/claude-code-tools/automation/auto-commit.sh << 'EOF'
#!/bin/bash
# Automated git commit with smart message generation

analyze_changes() {
    local changes=$(git diff --cached --name-status)
    local num_files=$(echo "$changes" | wc -l)
    local types=$(echo "$changes" | cut -f1 | sort | uniq -c)
    
    # Generate commit message based on changes
    if echo "$changes" | grep -q "^A"; then
        action="Add"
    elif echo "$changes" | grep -q "^M"; then
        action="Update"
    elif echo "$changes" | grep -q "^D"; then
        action="Remove"
    else
        action="Modify"
    fi
    
    # Get primary file or directory
    primary=$(echo "$changes" | head -1 | cut -f2 | cut -d'/' -f1)
    
    echo "$action $primary"
    [ $num_files -gt 1 ] && echo "- Modified $num_files files"
    echo "$changes" | while read status file; do
        echo "- ${status} ${file}"
    done
}

# Check for staged changes
if ! git diff --cached --quiet; then
    message=$(analyze_changes | head -1)
    details=$(analyze_changes | tail -n +2)
    
    echo "Commit message: $message"
    echo "$details"
    
    git commit -m "$message" -m "$details"
else
    echo "No staged changes to commit"
fi
EOF

chmod +x /opt/claude-code-tools/automation/auto-commit.sh

# 4. Create project templates
mkdir -p /opt/claude-code-tools/templates/{python-project,node-project}

# Python project template
cat > /opt/claude-code-tools/templates/python-project/setup.py << 'EOF'
from setuptools import setup, find_packages

setup(
    name="my-project",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[
        # Add dependencies here
    ],
)
EOF

cat > /opt/claude-code-tools/templates/python-project/requirements.txt << 'EOF'
pytest>=7.0.0
black>=22.0.0
flake8>=4.0.0
EOF

cat > /opt/claude-code-tools/templates/python-project/.gitignore << 'EOF'
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
.env
.venv
.pytest_cache/
.coverage
*.egg-info/
dist/
build/
EOF

# Node project template
cat > /opt/claude-code-tools/templates/node-project/package.json << 'EOF'
{
  "name": "my-project",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "test": "jest",
    "dev": "nodemon index.js"
  },
  "keywords": [],
  "author": "",
  "license": "MIT",
  "devDependencies": {
    "jest": "^29.0.0",
    "nodemon": "^3.0.0"
  }
}
EOF

# 5. Create database with useful data
sqlite3 /opt/claude-code-tools/databases/tools.db << 'EOF'
CREATE TABLE IF NOT EXISTS commands (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    command TEXT NOT NULL,
    category TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO commands (name, description, command, category) VALUES
('Find large files', 'Find files larger than 100MB', 'find . -type f -size +100M', 'filesystem'),
('Git undo last commit', 'Undo the last commit keeping changes', 'git reset --soft HEAD~1', 'git'),
('Docker cleanup', 'Remove unused Docker resources', 'docker system prune -a', 'docker'),
('Port in use', 'Check what is using a port', 'lsof -i :PORT', 'network'),
('JSON validate', 'Validate JSON file', 'python -m json.tool file.json', 'validation');

CREATE TABLE IF NOT EXISTS snippets (
    id INTEGER PRIMARY KEY,
    language TEXT NOT NULL,
    name TEXT NOT NULL,
    code TEXT NOT NULL,
    description TEXT
);

INSERT INTO snippets (language, name, code, description) VALUES
('python', 'read_json', 'import json\nwith open("file.json") as f:\n    data = json.load(f)', 'Read JSON file'),
('bash', 'error_handling', 'set -euo pipefail\ntrap "echo Error on line $LINENO" ERR', 'Bash error handling'),
('javascript', 'fetch_async', 'const response = await fetch(url);\nconst data = await response.json();', 'Async fetch');
EOF

# 6. Create quick launcher
cat > /opt/claude-code-tools/cc << 'EOF'
#!/bin/bash
# Claude Code Quick Launcher

case "$1" in
    search)
        source /opt/claude-code-tools/scripts/cc-utils.sh
        search_files "$2" "$3"
        ;;
    analyze)
        source /opt/claude-code-tools/scripts/cc-utils.sh
        analyze_project "$2"
        ;;
    serve)
        source /opt/claude-code-tools/scripts/cc-utils.sh
        serve_dir "$2"
        ;;
    monitor)
        source /opt/claude-code-tools/scripts/cc-utils.sh
        sys_monitor
        ;;
    json)
        python3 /opt/claude-code-tools/python-utils/cc_tools.py analyze-json "$2"
        ;;
    csv2db)
        python3 /opt/claude-code-tools/python-utils/cc_tools.py csv-to-sqlite "$2"
        ;;
    query)
        sqlite3 "$2" "$3" | column -t -s '|'
        ;;
    template)
        source /opt/claude-code-tools/scripts/cc-utils.sh
        create_from_template "$2" "$3"
        ;;
    backup)
        source /opt/claude-code-tools/scripts/cc-utils.sh
        backup_files "$2"
        ;;
    *)
        echo "Claude Code Tools - Quick Launcher"
        echo "================================="
        echo "Usage: cc <command> [args]"
        echo ""
        echo "Commands:"
        echo "  search <pattern> [path]  - Search files with preview"
        echo "  analyze [path]          - Analyze project structure"
        echo "  serve [port]           - Start HTTP server"
        echo "  monitor                - System resource monitor"
        echo "  json <file>            - Analyze JSON structure"
        echo "  csv2db <file>          - Convert CSV to SQLite"
        echo "  query <db> <sql>       - Query SQLite database"
        echo "  template <type> <name> - Create project from template"
        echo "  backup <path>          - Backup files/directories"
        ;;
esac
EOF

chmod +x /opt/claude-code-tools/cc
ln -sf /opt/claude-code-tools/cc /usr/local/bin/cc

# Create aliases file
cat > /opt/claude-code-tools/.claude_aliases << 'EOF'
# Claude Code Enhanced Aliases

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -la'
alias lt='ls -lat'

# Git shortcuts
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -10'

# Enhanced commands
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Claude Code specific
alias cc-utils='source /opt/claude-code-tools/scripts/cc-utils.sh'
alias cc-search='cc search'
alias cc-analyze='cc analyze'
alias cc-serve='cc serve'

# JSON operations
alias json-pretty='python3 -m json.tool'
alias json-validate='python3 -c "import json, sys; json.load(sys.stdin)"'

# Quick database
alias sql='sqlite3 -column -header'

# Python shortcuts
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Docker shortcuts
alias dps='docker ps'
alias dimg='docker images'
alias dexec='docker exec -it'

# System info
alias ports='netstat -tuln'
alias process='ps aux | grep'
EOF

echo "✓ Claude Code Enhancement Complete!"
echo ""
echo "Available tools:"
echo "1. Quick launcher: 'cc <command>'"
echo "2. Utilities: source /opt/claude-code-tools/scripts/cc-utils.sh"
echo "3. Python tools: /opt/claude-code-tools/python-utils/cc_tools.py"
echo "4. Automation scripts in: /opt/claude-code-tools/automation/"
echo "5. Database with commands: /opt/claude-code-tools/databases/tools.db"
echo ""
echo "To load aliases: source /opt/claude-code-tools/.claude_aliases"
echo "Quick start: Type 'cc' to see all available commands"
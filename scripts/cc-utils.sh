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

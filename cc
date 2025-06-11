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
        echo "  backup <path>          - Backup files/directories"
        ;;
esac
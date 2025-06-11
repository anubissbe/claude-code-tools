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

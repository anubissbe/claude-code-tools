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

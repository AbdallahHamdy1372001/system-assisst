#!/bin/bash

# sys_assistant.sh
# Author: Abdullah Hamdy
# Date: 2025-05-24
# Purpose: Lightweight system assistant for common sysadmin tasks

# Set secure permissions
#chmod 700 "$0"

# Function to show system info
system_info() {
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo "Load Average: $(uptime | awk -F'load average: ' '{print $2}')"
}

# Function to backup a folder
backup_folder() {
    read -rp "Enter source folder path: " src
    read -rp "Enter destination folder path: " dest
    if [[ -d "$src" ]]; then
        filename="backup_$(basename "$src")_$(date +%F_%H-%M-%S).tar.gz"
        tar -czf "$dest/$filename" "$src" && echo "Backup saved to $dest/$filename"
    else
        echo "Source folder does not exist!"
    fi
}

# Function to compare disk usage
compare_disk_usage() {
    read -rp "Enter first directory: " dir1
    read -rp "Enter second directory: " dir2
    if [[ -d "$dir1" && -d "$dir2" ]]; then
        size1=$(du -s "$dir1" | cut -f1)
        size2=$(du -s "$dir2" | cut -f1)
        echo "$dir1: $size1 KB"
        echo "$dir2: $size2 KB"
        if (( size1 > size2 )); then
            echo "$dir1 is larger"
        elif (( size2 > size1 )); then
            echo "$dir2 is larger"
        else
            echo "Both directories are equal in size"
        fi
    else
        echo "One or both directories do not exist!"
    fi
}

# Function to search for string in a file
search_string() {
    read -rp "Enter file path: " file
    read -rp "Enter search string: " str
    if [[ -f "$file" ]]; then
        grep --color=always -n "$str" "$file" || echo "String not found."
    else
        echo "File does not exist!"
    fi
}

# Function to create files using brace expansion
create_files() {
    read -rp "Enter prefix for files (e.g., file): " prefix
    eval touch "${prefix}"{1..5}.txt
    echo "Created files: ${prefix}1.txt to ${prefix}5.txt"
}

# Function to schedule a reminder
schedule_reminder() {
	
	read -rp "Enter time (e.g., now + 1 minute): " when
	read -rp "Enter reminder message: " msg
	echo "bash -c 'notify-send \"$msg\"'" | at "$when"

        echo "Reminder scheduled."
}

# Function to view or edit current cron jobs
manage_cron_jobs() {
    echo ""
    echo "=== Cron Job Manager ==="
    echo "1) View current cron jobs"
    echo "2) Edit cron jobs"
    echo "3) Return to main menu"
    read -rp "Choose an option: " choice

    case $choice in
        1)
            if crontab -l &>/dev/null; then
                echo ""
                crontab -l
            else
                echo "No crontab for current user."
            fi
            ;;
        2)
            crontab -e
            ;;
        3)
            return
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}


# Menu
while true; do
    echo ""
    echo "=== System Assistant Menu ==="
    select opt in "View System Info" "Backup Folder" "Compare Disk Usage" \
                  "Search String in File" "Create Files" "Schedule Reminder" \
                  "manage cron task" "Exit"; do
        case $REPLY in
            1) system_info; break ;;
            2) backup_folder; break ;;
            3) compare_disk_usage; break ;;
            4) search_string; break ;;
            5) create_files; break ;;
            6) schedule_reminder; break ;;
            7) manage_cron_jobs; break ;;
            8) echo "Goodbye!"; exit 0 ;;
            *) echo "Invalid option. Try again." ;;
        esac
    done
done

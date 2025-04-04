#!/bin/bash
# Cursor IDE Device ID Modifier for macOS
# Author: Bhaskarvilles
# Version: 1.0
# Description: Safely modifies Cursor IDE's device identification system.

# ========================
# CONFIGURATION
# ========================
LOG_FILE="/tmp/cursor_modifier.log"
CURSOR_APP="/Applications/Cursor.app"
BACKUP_DIR="$HOME/Library/Application Support/Cursor/User/globalStorage/backups"
STORAGE_FILE="$HOME/Library/Application Support/Cursor/User/globalStorage/storage.json"

# ========================
# INITIALIZATION
# ========================
init_log() {
    echo "=== Cursor ID Modifier Log ===" > "$LOG_FILE"
    echo "Started at: $(date)" >> "$LOG_FILE"
    echo "User: $(whoami)" >> "$LOG_FILE"
    echo "System: $(uname -a)" >> "$LOG_FILE"
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    echo "$1"
}

# ========================
# BACKUP & RESTORE
# ========================
backup_files() {
    mkdir -p "$BACKUP_DIR"
    log "Backing up files..."
    cp "$STORAGE_FILE" "$BACKUP_DIR/storage.json.bak_$(date +%Y%m%d_%H%M%S)" && log "Backup successful." || log "Backup failed."
}

restore_backup() {
    log "Available backups:"
    ls -l "$BACKUP_DIR" | grep ".bak_" >> "$LOG_FILE"
    read -p "Enter backup filename to restore: " backup_file
    cp "$BACKUP_DIR/$backup_file" "$STORAGE_FILE" && log "Restore successful." || log "Restore failed."
}

# ========================
# PATCH CURSOR FILES
# ========================
patch_cursor() {
    log "Patching Cursor.app..."
    # Replace hardcoded UUID with a random one
    sed -i '' 's/getMachineId() {.*}/getMachineId() { return "random-uuid-$(uuidgen)"; }/g' "$CURSOR_APP/Contents/Resources/app/out/main.js" && log "Patched main.js" || log "Failed to patch main.js"
    # Disable update checks
    echo "disabled" > "$CURSOR_APP/Contents/Resources/app-update.yml" && log "Disabled auto-updates." || log "Failed to disable updates."
}

# ========================
# MAIN EXECUTION
# ========================
main() {
    init_log
    log "Starting Cursor ID Modifier..."
    
    echo "1. Modify Cursor ID"
    echo "2. Restore Backup"
    echo "3. Exit"
    read -p "Choose an option (1-3): " choice

    case $choice in
        1)
            backup_files
            patch_cursor
            log "Modification complete. Restart Cursor."
            ;;
        2)
            restore_backup
            log "Restoration complete. Restart Cursor."
            ;;
        3)
            log "Exiting."
            exit 0
            ;;
        *)
            log "Invalid option."
            exit 1
            ;;
    esac
}

main

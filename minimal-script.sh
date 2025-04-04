#!/bin/bash
# Cursor ID Modifier for macOS
LOG_FILE="/tmp/cursor_patch.log"

echo "=== Starting Cursor Patch ===" | tee "$LOG_FILE"

# Backup original files
echo "Backing up Cursor files..." | tee -a "$LOG_FILE"
mkdir -p ~/cursor_backup
cp "/Applications/Cursor.app/Contents/Resources/app/out/main.js" ~/cursor_backup/main.js.bak 2>> "$LOG_FILE"

# Patch main.js to use random UUID
echo "Patching Cursor..." | tee -a "$LOG_FILE"
sed -i '' 's/getMachineId() {.*}/getMachineId() { return "random-"$(uuidgen); }/g' "/Applications/Cursor.app/Contents/Resources/app/out/main.js" 2>> "$LOG_FILE"

echo "Done! Restart Cursor." | tee -a "$LOG_FILE"

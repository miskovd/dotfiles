#!/bin/bash
# ================================================================
# Obsidian <-> Google Drive sync script via rclone bisync
#
# For the very first run use:
#     ./sync_obsidian.sh --init
# This will add the --resync flag to initialize synchronization.
#
# For all subsequent runs just use:
#     ./sync_obsidian.sh
# ================================================================

LOCKFILE="/tmp/sync_obsidian.lock"
LOCAL_DIR="/home/dimitri/Documents/obsidian"
REMOTE_DIR="gdrive:rclone/obsidian"
LOGFILE="/home/dimitri/.local/bin/sync_obsidian.log"

# Check if already running
if [ -f "$LOCKFILE" ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') — Already running, exiting." >>"$LOGFILE"
  exit 1
fi

touch "$LOCKFILE"

echo "=== $(date '+%Y-%m-%d %H:%M:%S') — Sync started ===" >>"$LOGFILE"

# Default rclone options
RCLONE_OPTS=(
  "--ignore-checksum"
  "--exclude" ".obsidian/workspace*.json"
  "--create-empty-src-dirs"
  "--verbose"
)

# Add --resync if first run
if [[ "$1" == "--init" ]]; then
  RCLONE_OPTS+=("--resync")
  echo "$(date '+%Y-%m-%d %H:%M:%S') — Running in initialization mode (--resync)" >>"$LOGFILE"
fi

# Run rclone bisync
rclone bisync "$LOCAL_DIR" "$REMOTE_DIR" "${RCLONE_OPTS[@]}" >>"$LOGFILE" 2>&1
STATUS=$?

# Log result
if [ $STATUS -eq 0 ]; then
  echo "=== $(date '+%Y-%m-%d %H:%M:%S') — Sync finished successfully ===" >>"$LOGFILE"
else
  echo "=== $(date '+%Y-%m-%d %H:%M:%S') — Sync failed (exit code $STATUS) ===" >>"$LOGFILE"
fi

echo "" >>"$LOGFILE"

rm -f "$LOCKFILE"

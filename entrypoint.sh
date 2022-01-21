#!/usr/bin/env bash
set -ue

[ -z "$STORAGE_DIR" ] && { echo "Must provide STORAGE_DIR in environment"; exit 1; }
[ -z "$CLIENT_SECRET" ] && { echo "Must provide CLIENT_SECRET in environment"; exit 1; }
[ -z "$B2_BUCKET" ] && { echo "Must provide B2_BUCKET in environment"; exit 1; }
[ -z "$B2_KEY_ID" ] && { echo "Must provide B2_KEY_ID in environment"; exit 1; }
[ -z "$B2_APP_KEY" ] && { echo "Must provide B2_APP_KEY in environment"; exit 1; }

# Download Photos
echo "⌛️ Downloading Google photos"
gphotos-sync --secret $CLIENT_SECRET --log-level INFO $STORAGE_DIR

# Sync Photos
echo "🌎 Syncing photos"
rclone config create backblaze b2
rclone sync $STORAGE_DIR backblaze:$B2_BUCKET --b2-account $B2_KEY_ID --b2-key $B2_APP_KEY --transfers 16 --copy-links --exclude=".*" -v

echo "✅ Succesfully synced Google photos"

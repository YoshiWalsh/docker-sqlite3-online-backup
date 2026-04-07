#!/bin/bash

LIVE_DB="${CRON:-"/db/sqlite.db"}"
BACKUP_DB="${CRON:-"/backup/backup.db"}"

rm /tmp/*.db
if [[ "$METHOD" == "VACUUM" ]]; then
    echo "Backing up database using VACUUM INTO"
    sqlite3 ${LIVE_DB} "VACUUM INTO '/tmp/backup.db';"
elif [[ "$METHOD" == "BOTH" ]]; then
    echo "1/2 - Snapshotting database using Online Backup API"
    sqlite3 ${LIVE_DB} ".backup '/tmp/snapshot.db'"
    echo "2/2 - Compacting snapshot using VACUUM INTO"
    sqlite3 /tmp/snapshot.db "VACUUM INTO '/tmp/backup.db';"
else
    echo "Backing up database using Online Backup API"
    sqlite3 ${LIVE_DB} ".backup '/tmp/backup.db'"
fi
rm /tmp/*.db

cp /tmp/backup.db ${BACKUP_DB}
echo "Backup complete"
#!/bin/bash

LIVE_DB="${LIVE_DB:-"/db/sqlite.db"}"
BACKUP_DB="${BACKUP_DB:-"/backup/backup.db"}"

rm /tmp/*.db > /dev/null 2>&1
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

cp /tmp/backup.db ${BACKUP_DB}
rm /tmp/*.db

echo "Backup complete"
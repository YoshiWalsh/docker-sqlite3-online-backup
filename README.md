# docker-sqlite3-online-backup

Simple docker container to make atomic backups of a live SQLite3 database on a schedule.

This container does not include any functionality for retaining multiple backups, backing up to remote destinations, or naming backups based on timestamps. Rather, it is intended for use in conjunction with a backup system such as restic.

## Environment variables:

### `CRON`

Specify the backup schedule in CRON syntax. Default value is "0 * * * *", which will take a backup at the start of each hour.

### `TIMEZONE`

Olson database timezone name to be used when interpreting CRON syntax. Defaults to "UTC".

### `LIVE_DB`

Location of the live database to be backed up. Defaults to "/db/sqlite.db".

NOTE: Remember to include any associated -wal and -shm files in your bind mount! It is recommended that you bind mount your entire database directory in to the container, and then use the `LIVE_DB` environment variable to specify the file name of your database.

### `BACKUP_DB`

Location to write the completed backup to. Defaults to "/backup/backup.db".

### `METHOD`

If **"ONLINE"** (or not specified, or any unrecognised value was provided), backs up the database using the Online Backup API.

This is suitable for backing up large databases while causing minimal blocking. The resulting backup represents a snapshot taken at the start of the backup process. The resulting backup may contain deleted content, and may be larger than necessary.

If **"VACUUM"**, backs up the databaase using `VACUUM INTO`.

This produces compact backup files at the expense of blocking writes during the backup process. The entire operation takes place in one single transaction.

If **BOTH**, snapshots database with Online Backup API, then `VACUUM`s the snapshot.

This combines the benefits of avoiding blocking writes for large databases, and producing compact backups with all deleted content purged. It comes at the expense of requiring more temporary storage space, and taking longer.
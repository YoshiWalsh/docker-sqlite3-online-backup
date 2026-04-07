#!/bin/bash

CRON="${CRON:-"0 * * * *"}"

if test -f "/usr/share/zoneinfo/${TIMEZONE}"; then
    ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/timezone
else
    ln -sf "/usr/share/zoneinfo/UTC" /etc/timezone
fi

echo "${CRON} bash /app/backup.sh" > /tmp/crontab

# foreground run crond
exec /usr/bin/supercronic -passthrough-logs -quiet "/tmp/crontab"
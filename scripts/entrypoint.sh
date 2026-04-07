#!/bin/bash

CRON="${CRON:-"0 * * * *"}"

if test -f "/usr/share/zoneinfo/${TIMEZONE}"; then
    ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /tmp/timezone
else
    ln -sf "/usr/share/zoneinfo/UTC" /tmp/timezone
fi

echo "${CRON} bash /app/backup.sh" > /tmp/crontab

echo "Container initialised!"
exec /usr/bin/supercronic -passthrough-logs -quiet "/tmp/crontab"
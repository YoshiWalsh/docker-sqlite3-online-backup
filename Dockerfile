# syntax=docker/dockerfile:1

FROM keinos/sqlite3

COPY scripts/*.sh /app/

RUN chmod +x /app/*.sh \
  && apk add --no-cache bash sqlite supercronic tzdata

ENTRYPOINT ["/app/entrypoint.sh"]
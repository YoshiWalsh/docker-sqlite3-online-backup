# syntax=docker/dockerfile:1

FROM keinos/sqlite3

USER root

COPY scripts/*.sh /app/

RUN chmod +x /app/*.sh \
  && apk add --no-cache bash sqlite supercronic tzdata \
  && ln -sf /tmp/timezone /etc/timezone

USER sqlite

ENTRYPOINT ["/app/entrypoint.sh"]
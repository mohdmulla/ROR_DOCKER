#!/bin/bash
set -e

# Remove any pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Run database migrations
bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:create db:migrate

# Run the main process
exec "$@"


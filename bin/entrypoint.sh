#!/bin/sh
set -e

# Make sure we are using the most up to date
# database schema
bundle exec rails db:migrate

# Do some protective cleanup
> log/production.log
rm -f tmp/pids/server.pid

exec "$@"

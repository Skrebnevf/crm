#!/bin/bash
set -e

# Create db directory if it doesn't exist
mkdir -p $HOME/db

# Initialize database if it doesn't exist yet
if [ ! -f "$HOME/db/fat_free_crm_development.sqlite3" ]; then
  echo "==> Database not found, initializing..."
  bundle exec rake db:schema:load RAILS_ENV=development
  echo "==> Database initialized."
fi

# Start Rails in development mode
exec bundle exec rails server -e development -b 0.0.0.0 -p ${PORT:-3000}

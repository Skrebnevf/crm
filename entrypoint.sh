#!/bin/bash
set -e

# Generate SECRET_KEY_BASE if not provided
if [ -z "$SECRET_KEY_BASE" ]; then
  export SECRET_KEY_BASE=$(bundle exec rake secret)
fi

# Create db directory if it doesn't exist
mkdir -p $HOME/db

# Initialize database if it doesn't exist yet
if [ ! -f "$HOME/db/fat_free_crm_production.sqlite3" ]; then
  echo "==> Database not found, initializing..."
  bundle exec rake db:schema:load RAILS_ENV=production
  echo "==> Database initialized."
fi

# Start Rails in production mode
exec bundle exec rails server -e production -b 0.0.0.0 -p ${PORT:-3000}

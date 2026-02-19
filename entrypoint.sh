#!/bin/bash
set -e

mkdir -p $HOME/db

# Флаг — файл-маркер, что БД уже была инициализирована
DB_INITIALIZED="$HOME/db/.initialized"

if [ ! -f "$DB_INITIALIZED" ]; then
  echo "==> [1/3] Создаём БД..."
  bundle exec rails db:create RAILS_ENV=development

  echo "==> [2/3] Загружаем схему..."
  bundle exec rails db:schema:load RAILS_ENV=development

  echo "==> [3/3] Создаём admin пользователя..."
  # Задайте USERNAME, PASSWORD, EMAIL через переменные окружения в Koyeb
  # Defaults: admin / admin / admin@example.com
  USERNAME=${ADMIN_USERNAME:-admin} \
  PASSWORD=${ADMIN_PASSWORD:-admin} \
  EMAIL=${ADMIN_EMAIL:-admin@example.com} \
  bundle exec rake ffcrm:setup:admin RAILS_ENV=development

  touch "$DB_INITIALIZED"
  echo "==> БД успешно инициализирована!"
fi

echo "==> Запускаем Rails сервер..."
exec bundle exec rails server -e development -b 0.0.0.0 -p ${PORT:-3000}

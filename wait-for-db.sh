#!/bin/sh

echo "Waiting for PostgreSQL at $DB_HOST:$DB_PORT..."

until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$PG_USER"; do
  echo "Postgres is unavailable - sleeping"
  sleep 2
done

echo "Postgres is up!"

command = [
  "sh", "-c",
  "./wait-for-db.sh forum-postgres 5432 &&
   python manage.py migrate --noinput &&
   python manage.py collectstatic --noinput &&
   gunicorn ..."
]

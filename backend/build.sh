#!/bin/bash
# Build script for Render deployment
# Performs production build steps: dependencies and static files

set -o errexit

echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Running database migrations..."
python manage.py migrate --noinput

python manage.py shell <<'PY'
import os
from django.contrib.auth import get_user_model

User = get_user_model()

username = os.environ.get("ADMIN_USERNAME", "admin")
email = os.environ.get("ADMIN_EMAIL", "")
password = os.environ.get("ADMIN_PASSWORD")

if not password:
    raise RuntimeError("ADMIN_PASSWORD environment variable is not set")

if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(
	 username=username,
	 email=email,
	 password=password,
    )
    print(f"Superuser '{username}' created successfully.")
else:
    print(f"Superuser '{username}' already exists.")
PY

echo "Build complete!"

#!/bin/bash
# Build script for Render deployment
# Performs production build steps: dependencies and static files

set -o errexit

echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Build complete!"

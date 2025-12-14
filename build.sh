#!/bin/bash
set -e

echo "Installing dependencies..."
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt

echo "Build completed successfully!"

# Start the app with Gunicorn
exec gunicorn --bind 0.0.0.0:$PORT --workers 1 --timeout 120 app:app

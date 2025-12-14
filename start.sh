#!/bin/bash
set -e

# تشغيل التطبيق مع Gunicorn
exec gunicorn --bind 0.0.0.0:$PORT --workers 1 --timeout 120 --access-logfile - --error-logfile - wsgi:app

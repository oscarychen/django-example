#!/bin/bash

python ./manage.py migrate

gunicorn django_example.wsgi:application \
     --bind 0.0.0.0:8000

#!/bin/bash
nginx
gunicorn --chdir src app:app -w 2 --bind 0.0.0.0:5000

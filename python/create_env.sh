#!/bin/bash
python3 -m venv venv
source ./venv/bin/activate
export FLASK_ENV=development
export FLASK_APP=app.py


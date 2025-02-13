#!/bin/bash

if [ ! -f ".env" ]; then
    echo "Error: .env file not found!"
    exit 1
fi

# Start Jitsi Meet services
docker-compose up

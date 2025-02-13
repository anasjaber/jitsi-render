FROM docker/compose:latest

WORKDIR /app

# Copy docker-compose file and any other necessary files
COPY docker-compose.yml .
COPY .env .

# Command to run docker-compose
CMD ["docker-compose", "up"]

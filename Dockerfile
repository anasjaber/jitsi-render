# Base image
FROM jitsi/base:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    docker.io \
    docker-compose \
    wget \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Download and extract the latest Jitsi Meet release
RUN wget $(curl -s https://api.github.com/repos/jitsi/docker-jitsi-meet/releases/latest | grep 'zip' | cut -d\" -f4) -O jitsi.zip && \
    unzip jitsi.zip && \
    rm jitsi.zip

# Copy configuration files
COPY .env /app/.env
COPY docker-compose.yml /app/docker-compose.yml
COPY gen-passwords.sh /app/gen-passwords.sh

# Make script executable
RUN chmod +x /app/gen-passwords.sh

# Create required directories
RUN mkdir -p ~/.jitsi-meet-cfg/{web,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

# Generate passwords if not already set
RUN ./gen-passwords.sh

# Expose necessary ports
EXPOSE 80 443 10000/udp 4443

# Start command
CMD ["docker-compose", "up"]

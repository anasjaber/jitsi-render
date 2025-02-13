# Use debian as base image since Jitsi is debian-based
FROM debian:bullseye-slim

# Set environment variables
ENV JITSI_IMAGE_VERSION=stable-10008
ENV CONFIG=/config
ENV TZ=UTC

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    wget \
    unzip \
    curl \
    ca-certificates \
    gnupg \
    apt-transport-https \
    lsb-release \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add Jitsi repository
RUN wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/" > /etc/apt/sources.list.d/jitsi-stable.list

# Create necessary directories
RUN mkdir -p /config/web /config/transcripts /config/prosody/config \
    /config/prosody/prosody-plugins-custom /config/jicofo /config/jvb \
    /config/web/crontabs /config/web/load-test

# Set working directory
WORKDIR /app

# Copy configuration files
COPY docker-compose.yml /app/
COPY .env /app/

# Install Docker and Docker Compose
RUN apt-get update && \
    apt-get install -y docker.io docker-compose && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create startup script
RUN echo '#!/bin/bash\n\
if [ ! -f ".env" ]; then\n\
    echo "Error: .env file not found!"\n\
    exit 1\n\
fi\n\
\n\
# Start Jitsi Meet services\n\
docker-compose up\n\
' > /app/start.sh && \
chmod +x /app/start.sh

# Expose ports
# Web
EXPOSE 80 443
# XMPP server
EXPOSE 5222 5269 5347 5280
# JVB
EXPOSE 10000/udp 8080
# Jicofo
EXPOSE 8888

# Set default command
CMD ["/app/start.sh"]

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/about/health || exit 1

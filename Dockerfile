# Use jitsi/web as base image
FROM jitsi/web:stable-10008

# Set environment variables
ENV JITSI_IMAGE_VERSION=stable-10008
ENV CONFIG=/config
ENV TZ=UTC

# Create necessary directories
RUN mkdir -p /config/web /config/transcripts \
    /config/web/crontabs /config/web/load-test

# Expose ports
EXPOSE 80 443

# The jitsi/web image uses /init as its entrypoint
CMD [ "/init" ]

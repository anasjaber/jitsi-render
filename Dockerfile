# Use jitsi/web as base image
FROM jitsi/web:stable-10008

# Set environment variables
ENV JITSI_IMAGE_VERSION=stable-10008
ENV CONFIG=/config
ENV TZ=UTC

# Copy web configurations
COPY ./config/web /config/web

# Expose ports
EXPOSE 80 443

# Set default command
CMD [ "/init" ]

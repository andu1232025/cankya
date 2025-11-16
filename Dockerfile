# Use Ubuntu 22.04 LTS
FROM ubuntu:22.04

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages and clean up
RUN apt-get update && \
    apt-get install -y tmate tzdata expect netcat && \
    ln -fs /usr/share/zoneinfo/Asia/Kathmandu /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/*

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Optional: Run as non-root user (security best practice)
# RUN useradd -m dev && chown dev:dev /start.sh
# USER dev

# Start the script
CMD ["/start.sh"]

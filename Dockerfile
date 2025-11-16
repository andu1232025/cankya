FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and set timezone during build
RUN apt-get update && \
    apt-get install -y tmate tzdata expect && \
    ln -fs /usr/share/zoneinfo/Asia/Kathmandu /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/*

# Copy and make executable start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Run as non-root if possible (optional but recommended)
# RUN useradd -m dev && chown dev:dev /start.sh
# USER dev

CMD ["/start.sh"]

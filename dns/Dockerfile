# Use Ubuntu as the base image
FROM ubuntu:latest

# Install BIND DNS server
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y bind9 && \
  rm -rf /var/lib/apt/lists/*

# Copy BIND configuration files
COPY named.conf.local /etc/bind/named.conf.local
COPY db.security.tn /etc/bind/db.security.tn

# Expose DNS ports
EXPOSE 53/udp
EXPOSE 53/tcp

# Start BIND DNS server
CMD ["named", "-g"]
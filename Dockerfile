# --------------------------
# 1️⃣ Builder Stage: Golang
# --------------------------
FROM golang:1.24 AS builder

WORKDIR /usr/src/app

# Pre-cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# --------------------------
# 2️⃣ Final Image
# --------------------------
FROM debian:stable-slim AS final

LABEL maintainer="YourName <jgrewal@po1.me>"
LABEL description="Unified APT Caching & Mirroring Container for Home Lab"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    APT_CACHER_NG_VERSION=3.7.1-1 \
    APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng \
    APT_CACHER_NG_USER=apt-cacher-ng

# Install required packages & clean up
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-cacher-ng \
    apt-mirror \
    ca-certificates \
    wget \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure APT-Cacher-NG
RUN sed -i 's/# ForeGround: 0/ForeGround: 1/' /etc/apt-cacher-ng/acng.conf \
    && sed -i 's/# PassThroughPattern:.*this would allow.*/PassThroughPattern: .* #/' /etc/apt-cacher-ng/acng.conf \
    && sed -i 's/# ExTreshold: 4/ExTreshold: 4/' /etc/apt-cacher-ng/acng.conf \
    && sed -i 's/# VerboseLog: 0/VerboseLog: 1/' /etc/apt-cacher-ng/acng.conf \
    && sed -i 's/# Debug: 0/Debug: 1/' /etc/apt-cacher-ng/acng.conf

# Setup working directories
RUN mkdir -p /var/lib/aptutil /var/spool/go-apt-mirror /var/spool/go-apt-cacher \
    && chown -R ${APT_CACHER_NG_USER}:${APT_CACHER_NG_USER} /var/cache/apt-cacher-ng

# Add mirror configuration
COPY mirror.list /etc/apt/mirror.list

# Set up entrypoint script
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

# Expose necessary ports
# Apt-Cacher-NG Web Interface
EXPOSE 3142

# Healthcheck to verify service is running
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD wget -q -t1 -O /dev/null http://localhost:3142/acng-report.html || exit 1

# Entrypoint and command
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/apt-cacher-ng"]

WORKDIR /var/lib/aptutil

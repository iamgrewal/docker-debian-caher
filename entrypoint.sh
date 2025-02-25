#!/bin/bash
set -e

# Ensure directories exist
mkdir -p /var/spool/apt-mirror
mkdir -p /var/lib/aptutil /var/spool/go-apt-mirror /var/spool/go-apt-cacher

# Start apt-mirror in the background
echo "Starting apt-mirror..."
nohup apt-mirror > /var/log/apt-mirror.log 2>&1 &

# Start apt-cacher-ng
echo "Starting apt-cacher-ng..."
exec /usr/sbin/apt-cacher-ng -c /etc/apt-cacher-ng

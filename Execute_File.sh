#!/bin/bash

# Build the Docker image
docker buildx build --platform linux/amd64,linux/arm64 -t yourdockerhub/apt-proxy:latest .

# Run the container
docker run -d --name apt-proxy \
  --restart unless-stopped \
  -p 3142:3142 \
  -v /data/apt-mirror:/var/spool/apt-mirror \
  -v /data/apt-cacher:/var/cache/apt-cacher-ng \
  yourdockerhub/apt-proxy:latest




  #Test apt caching:

echo 'Acquire::http::Proxy "http://your-server-ip:3142";' | sudo tee /etc/apt/apt.conf.d/01proxy
sudo apt update


# Test mirror functionality:
tail -f /var/log/apt-mirror.log
docker ps
docker exec -it apt-proxy /bin/bash
docker exec -it apt-proxy bash -c "apt-cacher-ng -c /etc/apt-cacher-ng -R"
docker exec -it apt-proxy nano /etc/apt/mirror.list
docker exec -it apt-proxy apt-mirror

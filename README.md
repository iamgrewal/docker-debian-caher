APT-Cacher-NG + APT-Mirror + APTUtil - Unified Home Lab Solution

This Docker image provides a unified solution for APT caching, mirroring, and utility management in a single container. Designed for home labs, it includes:
	•	APT-Cacher-NG for caching Debian-based package downloads (Ubuntu, Debian, etc.)
	•	APT-Mirror for mirroring repositories locally
	•	APTUtil to manage and optimize APT repositories

🚀 Features

✅ Multi-Platform Support (AMD64 & ARM64)
✅ Efficient Caching with APT-Cacher-NG
✅ Full Repository Mirroring with APT-Mirror
✅ Automatic Log & Health Monitoring
✅ Minimal Image Size for optimized deployment
✅ Persistent Storage Support

📦 Build & Run

1️⃣ Build the Multi-Arch Image

Run the following command to build the image for AMD64 & ARM64:

docker buildx build --platform linux/amd64,linux/arm64 -t yourdockerhub/apt-proxy:latest .

2️⃣ Run the Container

To start the APT caching & mirroring service:

docker run -d --name apt-proxy \
  --restart unless-stopped \
  -p 3142:3142 \
  -v /data/apt-mirror:/var/spool/apt-mirror \
  -v /data/apt-cacher:/var/cache/apt-cacher-ng \
  yourdockerhub/apt-proxy:latest

🔧 Configuration

APT-Cacher-NG

To use APT-Cacher-NG, configure your clients to use the cache proxy:

echo 'Acquire::http::Proxy "http://your-server-ip:3142";' | sudo tee /etc/apt/apt.conf.d/01proxy

Then, update your package lists:

sudo apt update

APT-Mirror

To start mirroring repositories:

docker exec -it apt-proxy apt-mirror

Check the logs:

docker logs -f apt-proxy

📜 Logs & Debugging
	•	APT-Mirror logs: /var/log/apt-mirror.log
	•	APT-Cacher logs: /var/log/apt-cacher-ng
	•	Docker logs: docker logs -f apt-proxy

To check service health:

docker ps
docker exec -it apt-proxy /bin/bash

🛠️ Maintenance

To clean up old cached files, run:

docker exec -it apt-proxy bash -c "apt-cacher-ng -c /etc/apt-cacher-ng -R"

To update mirror lists:

docker exec -it apt-proxy nano /etc/apt/mirror.list

To manually update repositories:

docker exec -it apt-proxy apt-mirror

🛠️ Troubleshooting

Issue	Solution
Cache not working	Ensure clients use http://your-server-ip:3142 as the proxy
Mirror not syncing	Check /var/log/apt-mirror.log for errors
Container not starting	Run docker logs apt-proxy and check for missing configurations

📜 License

This project is licensed under the MIT License.
Feel free to modify and use it as needed!

🙌 Contributing

Pull requests are welcome!
To contribute:
	1.	Fork this repository
	2.	Create a feature branch (feature-new)
	3.	Commit changes (git commit -m "Add new feature")
	4.	Push and open a Pull Request

📢 Credits

Created by @YourGitHubHandle 🎉
Maintained for home lab automation 🚀

🚀 Ready? Start caching & mirroring today! 🎯

Let me know if you need any tweaks! 🔥

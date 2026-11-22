# CSCE-465-HW4

## Setup

The tools needed for this lab are as follows:
 - Docker Engine 29.10.0
 - Docker Compose v5.8.0
 - Nmap 7.94SVN
 - tcpdump 4.99.4
 - Tshark 4.2.2
 - Suricata 8.0.8
 - iptables


### Docker Install
`sudo apt remove -y docker.io docker-compose docker-compose-v2 containerd runc 2>/dev/null || true`

`sudo install -m 0755 -d /etc/apt/keyrings`

`sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc`

`sudo chmod a+r /etc/apt/keyrings/docker.asc`

```
sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF_DOCKER
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF_DOCKER
```

`sudo apt update`

`sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`

`sudo usermod -aG docker "$USER"`

### Other Installs
`sudo apt install -y nmap tcpdump tshark netcat-openbsd`

`sudo add-apt-repository -y ppa:oisf/suricata-stable`

`sudo apt update`

`sudo apt install -y suricata`

`sudo usermod -aG suricata "$USER"`

### Installation Verification
Restart after all installs are complete

verify install with the following commands
`docker run --rm hello-world`

`docker --version`

`docker compose version`

`nmap --version`

`tshark --version`

`suricata -V`

## Network Simulation

To run the Docker network simulation, run `docker compose up`. Once this is running, you can enter into one of the nodes by running `docker exec -it {NODE} /bin/bash`.


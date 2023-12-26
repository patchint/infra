#!/bin/bash
# OpenSSH
echo -e "\n# Only enable RSA and ED25519 host keys.\nHostKey /etc/ssh/ssh_host_rsa_key\nHostKey /etc/ssh/ssh_host_ed25519_key\n\n# Restrict key exchange, cipher, and MAC algorithms\nKexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes256-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,rsa-sha2-512,rsa-sha2-256" >> /etc/ssh/sshd_config

rm /etc/ssh/ssh_host_*
ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe
mv /etc/ssh/moduli.safe /etc/ssh/moduli

sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

systemctl restart ssh

# unattended-upgrades
apt install -y unattended-upgrades
echo -e 'Unattended-Upgrade::Origins-Pattern {\n\t"origin=*";\n};\n\nUnattended-Upgrade::MinimalSteps "true";\nUnattended-Upgrade::Remove-Unused-Kernel-Packages "true";\nUnattended-Upgrade::Remove-New-Unused-Dependencies "true";\nUnattended-Upgrade::Remove-Unused-Dependencies "true";' > /etc/apt/apt.conf.d/50unattended-upgrades

# Docker
mkdir /root/.docker
echo "{}" > /root/.docker/config.json

apt install -y curl gnupg lsb-release vim rsync btrfs-progs
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

mkdir /root/.ssh
curl https://cdn.patchli.fr/keys/public_ssh.txt > /root/.ssh/authorized_keys

mkdir Docker && mkdir Docker/applications && touch Docker/docker-compose.yml


echo " " > /etc/motd

# done
apt autoremove && apt clean

ip a 

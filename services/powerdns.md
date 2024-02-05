# PowerDNS

## Installation des dépôts

```bash
echo "deb [signed-by=/etc/apt/keyrings/auth-48-pub.asc arch=amd64] http://repo.powerdns.com/debian bookworm-auth-48 main" > /etc/apt/sources.list.d/powerdns-auth-48.list
echo "deb [signed-by=/etc/apt/keyrings/rec-50-pub.asc arch=amd64] http://repo.powerdns.com/debian bookworm-rec-50 main" > /etc/apt/sources.list.d/powerdns-rec-50.list
echo "deb [signed-by=/etc/apt/keyrings/dnsdist-18-pub.asc arch=amd64] http://repo.powerdns.com/debian bookworm-dnsdist-18 main" > /etc/apt/sources.list.d/powerdns-dnsdist-18.list

echo "Package: auth*\nPin: origin repo.powerdns.com\nPin-Priority: 600" > /etc/apt/preferences.d/auth-48
echo "Package: rec*\nPin: origin repo.powerdns.com\nPin-Priority: 600" > /etc/apt/preferences.d/rec-50
echo "Package: dnsdist*\nPin: origin repo.powerdns.com\nPin-Priority: 600" > /etc/apt/preferences.d/dnsdist-18

install -d /etc/apt/keyrings; curl https://repo.powerdns.com/FD380FBB-pub.asc | tee /etc/apt/keyrings/auth-48-pub.asc
install -d /etc/apt/keyrings; curl https://repo.powerdns.com/FD380FBB-pub.asc | tee /etc/apt/keyrings/rec-50-pub.asc
install -d /etc/apt/keyrings; curl https://repo.powerdns.com/FD380FBB-pub.asc | tee /etc/apt/keyrings/dnsdist-18-pub.asc

```

## Installation des paquets

```bash
apt update
apt install pdns-server pdns-recursor dnsdist
```

## Configuration (Non terminée)

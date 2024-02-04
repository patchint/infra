# Cloud-Init Proxmox VE

Télécharger une image de Debian 

```bash
wget https://cloud.debian.org/images/cloud/bookworm-backports/latest/debian-12-backports-generic-amd64.qcow2
```

Créer la VM template
```bash
qm create 9000 --name template-deb2402 --cores 2 --memory 512 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
```

Copier l'image de Debian dans la VM
```bash
qm set 9000 --scsi0 local-lvm:0,import-from=/root/debian-12-backports-generic-amd64.qcow2
```

Changement de l'ordre de démarrage pour démarrer sur le disque
```bash
qm set 9000 --boot order=scsi0
```

Ajout de la configuration Cloud Init
```bash
qm set 9000 --ide2 local-lvm:cloudinit
```

Ajout d'un affichage
```bash
qm set 9000 --serial0 socket --vga serial0
```

Passage en mode template de la VM
```bash
qm template 9000
```

# Scripts

Dans ce dépôt git vous allez retrouver différents scripts que j'utilise au quotidien.

Pour l'instant il n'y a que des scripts pour du Linux, je n'utilise pas Windows Server.

## VPS

Dans le dossier VPS se trouve des scripts que j'exécute de la création d'un VPS chez un hébergeur (OVH, Hetzner...) ou sur une VM en local comme sur VMWare.

## VM-CloudInit

Dans le dossier vm-cloudinit, vous allez retrouver une série de script que j'utilise pour pouvoir créer, gérer et supprimer des VM uniquement depuis le CLI.

J'utilise virt-install, virsh et cloud-init pour tout configurer, pour se faire vous devez les installer.

### Pré-Installation

Sur Debian : 

```bash
sudo apt install -y --no-install-recommends qemu-system libvirt-clients libvirt-daemon-system virtinst git
sudo adduser <utilisateur> libvirt
```

Maintenant, vous pouvez installer les différents scripts à l'aide de ces commandes :

```bash
git clone https://git.patchli.fr/patch/scripts
cd scripts
cp vm-cloudinit/* /usr/bin/
chmod +x /usr/bin/create_vm /usr/bin/getip_vm /usr/bin/ssh_vm /usr/bin/delete_vm
```

Vous pouvez maintenant utiliser les commandes create_vm, getip_vm, ssh_vm et delete_vm !

### Utilisation

#### create_vm

La commande create_vm se présente de cette manière : 

```
Entrer le nom de la VM: prout # On rentre le nom de sa VM
Choisir un OS: # On choisis un OS
1) Archlinux
2) Debian
3) Fedora
4) Ubuntu
#? 2 # Là par exemple j'ai mis Debian
Choisir la taille du stockage: # On choisis son espace de stockage
1) 10G
2) 20G
3) 30G
4) Personnaliser # On peut aussi le personnaliser, donc on rentre la valeur qu'on veut par exemple 600 (c'est beaucoup)
#? 1 # Dans mon cas j'ai pris 10Go
Using default --name prout # Puis la VM se fait toute seule
WARNING  Using --osinfo generic, VM performance may suffer. Specify an accurate OS for optimal results.

Starting install...
Allocating 'prout.qcow2'                                      |    0 B  00:00 ... 
Creating domain...                                          |    0 B  00:00     
Domain creation completed. # Oh c'est fini !
```


!!!! Pas fini !!!!

## Utilitaire

Dans ce dossier se trouve des scripts qui peuvent m'être utile parfois.
#!/bin/bash

display_help() {
    echo "Utilisation: $0 <Dossier source> <Dossier de destination> [options]"
    echo "Options:"
    echo "  -h                      Afficher l'aide."
    echo "  -j <jours>              Nettoyer les sauvegardes plus vieilles que n jours."
    echo "  -c                      Compresser les sauvegardes en zstd avec tar."
    echo
    echo "patchli_fr"
    exit 1
}

if [ "$#" -lt 2 ]; then
    display_help
fi

# Exemple de ce que pourrait contenir le fichier config.conf
# compress_user=true
# days_to_keep_user=7
# destination_folder_user=backup

config_file="config.conf"

if [ -f "$config_file" ]; then
    source "$config_file"
fi

# Initialiser les variables avec les valeurs par défaut du fichier de configuration
compress=${compress_user:-false}
days_to_keep=${days_to_keep_user:-0}
destination_folder=${destination_folder_user:-""}

# Cherche les options utilisées par l'utilisateur
while getopts ":hj:c:" opt; do
    case $opt in
        h)  # Afficher l'aide
            display_help
            ;;
        j)  # Supprimer les backup après N jours
            days_to_keep="$OPTARG"
            ;;
        c)  # Compresser la backup
            compress_candidate="$OPTARG"
            ;;
        \?) # Option invalide
            echo "Option invalide: -$OPTARG"
            display_help
            ;;
    esac
done

if [ -n "$compress_candidate" ]; then
    case "$compress_candidate" in
        true)
            compress=true
            ;;
        false)
            compress=false
            ;;
        *)
            echo "Valeur invalide pour l'option -c. Utilisez 'true' ou 'false'."
            display_help
            ;;
    esac
fi

shift $((OPTIND-1))

source="$1"
destination="$2"
date=$(date +"%Y-%m-%d")
user=$(whoami)

# Ajoute le nombre de jours spécifiques pour garder les backups
if [ "$days_to_keep" -gt 0 ]; then
    clean_date=$(date -d "-$days_to_keep days" +"%Y-%m-%d")
fi

if [ ! -d "$source" ] || [ ! -r "$source" ]; then
    echo "Le dossier source n'existe pas ou n'est pas lisible"
    exit 1
fi

# Si l'utilisateur a spécifié une destination en ligne de commande, utilisez-la
# Sinon, utilisez la destination définie dans le fichier de configuration
if [ -n "$2" ]; then
    destination="$2"
elif [ -n "$destination_folder_user" ]; then
    destination="$destination_folder_user"
fi

# Créer le dossier de l'utilisateur qui utilise le programme
# Exemple : backup/patchli_fr
user_destination="$destination/$user"
if [ ! -d "$user_destination" ]; then
    mkdir -p "$user_destination"
    if [ $? -ne 0 ]; then
        echo "Impossible de créer le dossier de destination de l'utilisateur"
        exit 1
    fi
fi

# Créer le dossier de destination dans le dossier prévu pour l'utilisateur avec la date de la backup
# Exemple : backup/patchli_fr/2023-12-15
destination_folder="$user_destination/$date"
if [ ! -d "$destination_folder" ]; then
    mkdir -p "$destination_folder"
    if [ $? -ne 0 ]; then
        echo "Impossible de créer le dossier de destination pour la date"
        exit 1
    fi
fi

# Si l'option de compression est utilisée, utiliser tar avec la compression zstd
if [ "$compress" = true ]; then
    tar -cf "$destination_folder/backup-$date-$user.tar.zst" --directory="$source" .
else
    rsync -a -u "$source/" "$destination_folder"
fi

# Supprimer les anciennes backup si la variable clean_date est saisie
if [ -n "$clean_date" ]; then
    find "$user_destination" -type d -name "$clean_date*" -exec rm -r {} \;
fi

echo "Le dossier $source a bien été copié vers $destination_folder."

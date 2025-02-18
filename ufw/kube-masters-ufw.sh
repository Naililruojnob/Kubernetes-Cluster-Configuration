#!/bin/bash

# Vérifie si UFW est installé
if ! command -v ufw &> /dev/null
then
    echo "UFW n'est pas installé. Installation en cours..."
    sudo apt update
    sudo apt install -y ufw
else
    echo "UFW est déjà installé."
fi

# Définir la liste des workers autorisés (remplace par les IPs de tes workers)
WORKERS=("ip" "ip" "ip")

# Réinitialiser UFW et appliquer une politique par défaut stricte
ufw --force reset
ufw default deny incoming  # Bloquer tout le trafic entrant par défaut
ufw default allow outgoing  # Autoriser tout le trafic sortant par défaut


# Autoriser l'accès au Kubernetes API server depuis tous
ufw allow proto tcp from any to any port 6443 comment "Autoriser API server Kubernetes"

# Activer UFW avec les nouvelles règles
ufw --force enable

# Afficher le statut et la configuration actuelle de UFW
ufw status verbose

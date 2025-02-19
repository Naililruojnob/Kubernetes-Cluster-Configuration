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

# Définir la liste des masters et workers autorisés (remplace par les IPs de tes Masters et Workers)
MASTERS=("IP_MASTER_1" "IP_MASTER_2")
WORKERS=("IP_WORKER_1" "IP_WORKER_2")

# Réinitialiser UFW et appliquer une politique par défaut stricte
ufw --force reset
ufw default deny incoming  # Bloquer tout le trafic entrant par défaut
ufw default allow outgoing  # Autoriser tout le trafic sortant par défaut

# Autoriser les connexions depuis les masters et workers
for IP in "${MASTERS[@]}" "${WORKERS[@]}"; do
    ufw allow from $IP comment "Autoriser les connexions depuis $IP"
done

## (optionel) Autoriser les NodePort Services pour les communications internes
# ufw allow proto tcp from any to any port 30000:32767 comment "Autoriser NodePort Services"

# Activer UFW avec les nouvelles règles
ufw --force enable

# Afficher le statut et la configuration actuelle de UFW
ufw status verbose

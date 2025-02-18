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

# Définir la liste des masters autorisés (remplace par les IPs de tes Masters)
MASTERS=("IP")

# Réinitialiser UFW et appliquer une politique par défaut stricte
ufw --force reset
ufw default deny incoming  # Bloquer tout le trafic entrant par défaut
ufw default allow outgoing  # Autoriser tout le trafic sortant par défaut

# Autoriser kubelet API (auto-administré par le nœud lui-même et accessible par le control plane)
for MASTERS in "${MASTERS[@]}"; do
	ufw allow proto tcp from $MASTERS to any port 10250 comment "Autoriser kubelet API pour le control plane"
done
## (optionel) Autoriser les NodePort Services pour les communications internes
# ufw allow proto tcp from any to any port 30000:32767 comment "Autoriser NodePort Services"

# Activer UFW avec les nouvelles règles
ufw --force enable

# Afficher le statut et la configuration actuelle de UFW
ufw status verbose

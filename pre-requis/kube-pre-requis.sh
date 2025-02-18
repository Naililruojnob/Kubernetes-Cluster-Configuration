#!/bin/bash

K8S_VERSION="1.32"

### Mettre à jour et installer les dépendances
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y curl apt-transport-https ca-certificates software-properties-common containerd

### Désactiver le swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

### Charger les modules du noyau
sudo modprobe overlay
sudo modprobe br_netfilter

### Charger les modules au démarrage du système
echo -e "overlay\nbr_netfilter" | sudo tee /etc/modules-load.d/k8s.conf

### Configurer le noyau
echo -e "net.bridge.bridge-nf-call-iptables  = 1\nnet.bridge.bridge-nf-call-ip6tables = 1\nnet.ipv4.ip_forward                 = 1" | sudo tee /etc/sysctl.d/k8s.conf

# Appliquer la configuration du noyau
sudo sysctl --system

### Configurer containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

### Activer le driver cgroup de systemd
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

### Redémarrer et activer containerd au démarrage
sudo systemctl restart containerd
sudo systemctl enable containerd

## Installation de Kubernetes

### Ajouter le dépôt Kubernetes et sa clé
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

### Installer Kubernetes
sudo apt update -y
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

### Démarrer et activer kubelet
sudo systemctl start kubelet
sudo systemctl enable kubelet

echo "Installation des prérequis Kubernetes terminée."

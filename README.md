# Kubernetes-Cluster-Configuration

## Pre-requis masters and workers

[kube-pre-requis.sh](https://github.com/Naililruojnob/Kubernetes-Cluster-Configuration/blob/e911c7d8bf47e0bcd59c62f7c761a7e2b1124d5e/pre-requis/kube-pre-requis.sh)

## Configure masters

[kube-masters.sh](https://github.com/Naililruojnob/Kubernetes-Cluster-Configuration/blob/e911c7d8bf47e0bcd59c62f7c761a7e2b1124d5e/pre-requis/kube-masters.sh)

## ufw Masters

[kube-masters-ufw.sh](https://github.com/Naililruojnob/Kubernetes-Cluster-Configuration/blob/e911c7d8bf47e0bcd59c62f7c761a7e2b1124d5e/ufw/kube-masters-ufw.sh)

## ufw workers

[kube-workers-ufw.sh](https://github.com/Naililruojnob/Kubernetes-Cluster-Configuration/blob/e911c7d8bf47e0bcd59c62f7c761a7e2b1124d5e/ufw/kube-workers-ufw.sh)

## hosts

```bash
cat <<EOF | sudo tee -a /etc/hosts


# Kubernetes Masters 

192.168.0.151 kube-masters-001 

# < IP > kube-masters-xxx

# Kubernetes Workers

192.168.0.152 kube-workers-001
192.168.0.153 kube-workers-002
192.168.0.154 kube-workers-003

# < IP > kube-workers-xxx 

EOF
```

## Networks

Nœuds maîtres

| Protocole | Direction | Plage de Port | Utilisé pour            | Utilisé par             |
| --------- | --------- | ------------- | ----------------------- | ----------------------- |
| TCP       | Entrant   | 6443*         | Kubernetes API server   | Tous                    |
| TCP       | Entrant   | 2379-2380     | Etcd server client API  | kube-apiserver, etcd    |
| TCP       | Entrant   | 10250         | Kubelet API             | Lui-même, Control plane |
| TCP       | Entrant   | 10251         | kube-scheduler          | Lui-même                |
| TCP       | Entrant   | 10252         | kube-controller-manager | Lui-même                |

Nœuds workers

| Protocole | Direction | Plage de Port | Utilisé pour        | Utilisé par             |
| --------- | --------- | ------------- | ------------------- | ----------------------- |
| TCP       | Entrant   | 10250         | Kubelet API         | Lui-même, Control plane |
| TCP       | Entrant   | 30000-32767   | NodePort Services** | Eux-mêmes               |

## Ajout d’un nœud dans le cluster Kubernetes

### Récupération du token sur un des masters

```bash
sudo kubeadm token create --print-join-command





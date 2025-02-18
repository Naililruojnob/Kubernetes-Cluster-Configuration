### Initialiser le cluster Kubernetes

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 \

             --apiserver-advertise-address=<IP>

#--pod-network-cidr : Spécifier une plage d’adresses pour le réseau des pods.  
#--apiserver-advertise-address : Spécifier l’adresse IP d’écoute de l’API Kubernetes.

### Copier la configuration dans le répertoire de l’utilisateur courant

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

### Indiquer à Kubernetes où trouver sa configuration

echo 'export KUBECONFIG=$HOME/.kube/config' >> $HOME/.bashrc
source ~/.bashrc

#### Lister les nodes

kubectl get nodes -o wide

### Installer de Calico

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

### Vérification

kubectl get pods -n kube-system -o wide

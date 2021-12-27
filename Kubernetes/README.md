# Table of contents
1. [Installation](#installation)
2. [Storage](#storage)


# Installation <a name="installation"></a>
## Install Minikube CentOS 
```sh
#!/bin/bash
sudo yum -y update
sudo yum -y install epel-release
sudo yum -y install libvirt qemu-kvm virt-install virt-top libguestfs-tools bridge-utils
yum install socat -y
sudo yum install -y conntrack
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker centos
systemctl start docker
sudo yum -y install wget
sudo wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo chmod +x minikube-linux-amd64
sudo mv minikube-linux-amd64 /usr/bin/minikube
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
sudo chmod +x kubectl
sudo mv kubectl  /usr/bin/
sudo echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
sudo systemctl enable docker.service
```
## Install Minikube Ubuntu
```sh
#!/bin/bash
sudo hostnamectl set-hostname minikube-master
echo "127.0.0.1 minikube-master" >> /etc/hosts
sudo apt-get -y update
sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager
sudo apt-get install -y socat
sudo apt-get install -y conntrack
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu
systemctl start docker
sudo apt-get -y install wget
sudo wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo chmod +x minikube-linux-amd64
sudo mv minikube-linux-amd64 /usr/bin/minikube
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
sudo chmod +x kubectl
sudo mv kubectl  /usr/bin/
sudo echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
sudo systemctl enable docker.service
```
## Démarrer/Arrêter minikube
```sh
minikube start --driver=none
sudo minikube delete
```
## Activer l'autocomplétion kubernetes
```sh
echo 'source <(kubectl completion bash)' >> ${HOME}/.bashrc
echo 'source <(kubectl completion bash)' >> ${HOME}/.bashrc && source ${HOME}/.bashrc
```
## Activer Ingress
```sh
minikube addons enable ingress
kubectl get ns
kubectl get po -n ingress-nginx
```

# Storage <a name="storage"></a>
## Volumes
```yaml
spec:
  volumes:
  - name: data-volume
    hostPath:
      path: /data
      type: Directory  # also DirectoryOrCreate
```

## Persistent volumes
(No imperative command for creation)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-vol1
spec:
  accessModes:
  - ReadWriteOnce    # also possible: ReadOnlyMany, ReadWriteMany
  capacity:
    storage: 1Gi
  awsElasticBlockStore:
    volumeID: <volume-id>
    fsType: ext4
```

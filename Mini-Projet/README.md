# Mini-Projet - Déployez Wordpress à l’aide de manifests

<br />

## I-	Création de l’instance sur AWS

<br />

![screenshot001](./sources/IMG-001.png)

<br />

![screenshot002](./sources/IMG-002.png)

<br />

![screenshot003](./sources/IMG-003.png)

<br />

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

<br />

![screenshot004](./sources/IMG-004.png)

<br />

![screenshot005](./sources/IMG-005.png)

<br />

![screenshot006](./sources/IMG-006.png)

<br />

![screenshot007](./sources/IMG-007.png)

<br />

![screenshot008](./sources/IMG-008.png)

<br />

## II-	Installation de minikube

<br />

```sh
minikube start --driver=none
```
<br />

![screenshot009](./sources/IMG-009.png)

<br />

![screenshot010](./sources/IMG-010.png)

<br />

* **On active l'autocomplétion kubernetes**
```sh
echo 'source <(kubectl completion bash)' >> ${HOME}/.bashrc
```

<br />

## III-	Création des manifests

<br />

* **Création du manifest de secret pour la connexion à mySQL**

```sh
vi secret.yaml
```
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
type: Opaque
data:
  mysql_user: cmVuYXVkCg==
  mysql_pwd: c2F1dG91cgo=
  mysql_root_pwd: cGFzc3dvcmQK
```

</br>

```sh
kubectl apply -f secret.yaml
```

**************************************************

* **Création du manifest de déploiement de mySQL**
```sh
vi deploy-mysql.yaml
```
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rsmysql
  labels:
    role: bdd
spec:
  replicas: 1
  selector: 
    matchLabels:
      app: mysql
  template:
    metadata:
      name: mysql
      labels:
        app: mysql
        type: pod
    spec:
      containers:
        - name: mysql
          image: mysql
          env:
            - name: MYSQL_USER 
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: mysql_user
            - name: MYSQL_PASSWORD 
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: mysql_pwd
            - name: MYSQL_DATABASE 
              value: easytraining
            - name: MYSQL_ROOT_PASSWORD 
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: mysql_root_pwd
          ports:
            - containerPort: 3306
#lien du volume à utiliser pour cet hote  
          volumeMounts:
            - mountPath: /var/lib/mysql
              name: mysql-data
#creation du volume
      volumes: 
        - name: mysql-data
          hostPath:
            path: /db-data
            type: DirectoryOrCreate
```
</br>

* **On lance le déploiement et on vérifie le montage:**
```sh
kubectl apply -f deploy-mysql.yaml

ls /
```
![screenshot011](./sources/IMG-011.png)

</br>

* **Création du manifest du service custerIP pour exposer le pod mySQL**
```sh
vi service-mysql.yaml
```
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
spec:
  type: ClusterIP
  ports:
    - targetPort: 3306
      port: 3306
  selector:
        app: mysql
```

</br>

* **On lance le service:**
```sh
kubectl apply -f service-mysql.yaml
```

**************************************************

* **Création du manifest de déploiement de wordpress**
```sh
vi deploy-wordpress.yaml
```
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rswordpress
  labels:
    role: front
spec:
  replicas: 1
  selector: 
    matchLabels:
      app: wordpress
  template:
    metadata:
      name: wordpress
      labels:
        app: wordpress
        type: pod
    spec:
      containers:
        - name: wordpress
          image: wordpress
          env:
            - name: WORDPRESS_DB_USER 
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: mysql_user
            - name: WORDPRESS_DB_PASSWORD 
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: mysql_pwd
            - name: WORDPRESS_DB_NAME 
              value: easytraining
            - name: WORDPRESS_DB_HOST 
              value: mysql-service
#lien du volume à utiliser pour cet hote  
          volumeMounts:
            - mountPath: /var/www/html
              name: wordpress-data
#creation du volume
      volumes: 
        - name: wordpress-data
          hostPath:
            path: /data
            type: DirectoryOrCreate
```

* **On lance le déploiement et on vérifie le montage:**
```sh
kubectl apply -f deploy-wordpress.yaml

ls /
```
![screenshot012](./sources/IMG-012.png)

</br>

* **Création du manifest du service nodePort pour exposer le frontend wordpress**
```sh
vi service-wordpress.yaml
```
```yaml
apiVersion: v1
kind: Service
metadata:
  name: wordpress-service
spec:
  type: NodePort
  ports:
    - targetPort: 80
      port: 80
      nodePort: 30009
  selector:
        app: wordpress
```

</br>

* **On lance le service:**
```sh
kubectl apply -f service-wordpress.yaml
```

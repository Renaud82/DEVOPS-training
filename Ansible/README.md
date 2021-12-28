# Ansible

### Table des matières
I. [Installation](#install)<br />
&nbsp;&nbsp;&nbsp;A. [Création de 3 machines cloud ec2](#ec2)<br />
&nbsp;&nbsp;&nbsp;B. [Installation ansible via l'outil PIP3 de python](#install)<br />
II. [Build Image](#docker)<br />
III. [Pipeline](#pipeline)<br />
&nbsp;&nbsp;&nbsp;A. [Création des credentials](#credential)<br />
&nbsp;&nbsp;&nbsp;B. [Création du pipeline](#pipelinecreation)<br />
&nbsp;&nbsp;&nbsp;C. [Lancement du pipeline](#pipelinelaunch)<br />
IV. [Ajout de plugin au Pipeline](#pugin)<br />
&nbsp;&nbsp;&nbsp;A. [Trigger GitHub](#trigger)<br />
&nbsp;&nbsp;&nbsp;B. [Embeddable Build Status](#embeddable)<br />
&nbsp;&nbsp;&nbsp;C. [Slack notification](#slack)<br />
&nbsp;&nbsp;&nbsp;D. [Test du pipeline](#test)<br />

## I- Installation <a name="install"></a>
### A – Création d’une machine cloud ec2 (renaud-ec2-prod) <a name="ec2"></a>
![screenshot001](./images/IMG-001.png)
3 amchines AWS

* Ubuntu (renaud-ec2-master, renaud-ec2-worker01, renaud-ec2-worker02)
* EC2 : t3.medium, t2.micro (x2)
* 8 Go
* renaud-sg-ansible : 22
* master: 3.231.223.229 , worker01: 3.91.213.82 , worker02: 3.88.215.129


### B – Installation ansible <a name="install"></a>TP1

* Utilisation de utilitaire pip

```sh
python3 --version
sudo apt-get -y update
sudo apt-get -y install python3-pip
sudo pip3 install ansible

ansible --version
------------
ansible [core 2.12.1]
  config file = None
  configured module search path = ['/home/ubuntu/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.8/dist-packages/ansible
  ansible collection location = /home/ubuntu/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible
  python version = 3.8.10 (default, Nov 26 2021, 20:14:08) [GCC 9.3.0]
  jinja version = 2.10.1
  libyaml = True
------------
```

* Utilisation du gestionnaire de packets

```sh
#!/bin/bash
sudo apt-get update
sudo apt-get install ansible
sudo yum install ansible
```

### C – Gestion de l'inventaire

* IP privées
master: 172.31.6.38
worker01: 172.31.82.253
worker02: 172.31.93.193

```sh
sudo apt-get install sshpass -y
vi hosts
```
**hosts:**
```sh
172.31.82.253 ansible_user=ubuntu ansible_password=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

```sh
ansible -i hosts all -m ping
------------
172.31.82.253 | FAILED! => {
    "msg": "to use the 'ssh' connection type with passwords or pkcs11_provider, you must install the sshpass program"
}
------------
sudo apt-get -y install sshpass
ansible -i hosts all -m ping
------------
172.31.82.253 | UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to connect to the host via ssh: Warning: Permanently added '172.31.82.253' (ECDSA) to the list of known hosts.\r\nubuntu@172.31.82.253: Permission denied (publickey).",
    "unreachable": true
}
------------
```

* On doit activativer de l'authentification par password sur les clients

```sh
sudo vi /etc/ssh/sshd_config      =>  PasswordAuthentication yes
sudo systemctl restart ssh
sudo -i
passwd ubuntu

ansible -i hosts all -m ping
------------
172.31.82.253 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
------------
```

* Modification du hosts

```sh
vi hosts
```
**hosts:**
```sh
worker01 ansible_host=172.31.82.253 ansible_user=ubuntu ansible_password=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```
```sh
ansible -i hosts all -m ping
------------
worker01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
------------
```

### D – Module Copy

```sh
ansible -i hosts all -m copy -a "dest=/home/ubuntu/renaud.txt content='Bonjour Renaud'"
```

### D – Module Package



********
TP3
********

* Inventaire

```sh
vi hosts
```
**hosts:**
```sh
worker01 ansible_host=172.31.82.253 ansible_user=ubuntu ansible_password=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no'
worker02 ansible_host=172.31.93.193 ansible_user=ubuntu ansible_password=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

```sh
ansible -i hosts all -m ping
------------
worker01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
worker02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
------------
```

* Installation

```sh
ansible -i hosts -b -m package -a "name=nginx state=present" worker01
ansible -i hosts -b -m service -a "name=nginx state=started enabled=yes" worker01

ansible -i hosts -b -m package -a "name=apache2 state=present" worker02
ansible -i hosts -b -m service -a "name=apache2 state=started enabled=yes" worker02
```

On ouvre le port 80 du security Group


* Désinstallation

```sh
ansible -i hosts -b -m package -a "name=nginx state=absent purge=yes autoremove=yes" worker01

ansible -i hosts -b -m package -a "name=apache2 state=absent purge=yes autoremove=yes" worker02
```

Vérification que le service ne tourne plus:
```sh
#worker01
ps -ef | grep nginx
#worker02
ps -ef | grep apache2
```

### E – Inventaire au format yaml

****
TP 4a
****
```sh
vi hosts.yaml
```
**hosts.yaml:**
```yaml
all:
  hosts:
    worker01:
      ansible_host: 172.31.82.253
      ansible_user: ubuntu
      ansible_password: ubuntu
      ansible_ssh_common_args: '-o StrictHostKeyChecking=no'

    worker02: 
      ansible_host: 172.31.93.193
      ansible_user: ubuntu
      ansible_password: ubuntu
      ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
```
```sh
ansible -i hosts.yaml -m ping all
```

### E – Module Setup

****
TP 4b
****

```sh
ansible -i hosts.yaml all -m setup 
ansible -i hosts.yaml all -m setup | grep -i hostname
ansible -i hosts.yaml all -m setup | grep ansible_distribution
```

```sh
vi hosts.yaml
```
**hosts.yaml:**
```yaml
all:
  hosts:
    worker01:
      ansible_host: 172.31.82.253
      ansible_user: ubuntu
      ansible_password: ubuntu
      ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
      env: 'prod'
    worker02:
      ansible_host: 172.31.93.193
      ansible_user: ubuntu
      ansible_password: ubuntu
      ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
```
```sh
ansible -i hosts.yaml all -m debug -a "msg= {{  env }} "
------------
worker02 | FAILED! => {
    "msg": "The task includes an option with an undefined variable. The error was: 'env' is undefined. 'env' is undefined"
}
worker01 | SUCCESS => {
    "msg": "prod"
}
------------
```


### F – Module Setup

****
TP 5
****


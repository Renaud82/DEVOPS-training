# Ansible

### Table des matières
I. [Installation](#install)<br />
&nbsp;&nbsp;&nbsp;A. [Création de 3 machines cloud ec2](#ec2)<br />
&nbsp;&nbsp;&nbsp;B. [Installation ansible](#ansible)<br />
II. [Manifest](#manifest)<br />
&nbsp;&nbsp;&nbsp;A. [Gestion de l'inventaire](#inventaire)<br />
&nbsp;&nbsp;&nbsp;B. [Module Copy](#copy)<br />
&nbsp;&nbsp;&nbsp;C. [Module Package](#package)<br />
&nbsp;&nbsp;&nbsp;D. [Inventaire au format yaml](#yaml)<br />
&nbsp;&nbsp;&nbsp;E. [Module Setup](#setup)<br />
&nbsp;&nbsp;&nbsp;F. [Les formats de l'inventaire](#multi)<br />
&nbsp;&nbsp;&nbsp;F. [Variables](#variable)<br />
III. [Playbook](#playbook)<br />
&nbsp;&nbsp;&nbsp;A. [Utilisation du playbook](#useplaybook)<br />
&nbsp;&nbsp;&nbsp;B. [Templating Jinja](#jinja)<br />
&nbsp;&nbsp;&nbsp;C. [When et loop](#when)<br />
&nbsp;&nbsp;&nbsp;D. [Include et Import](#include)<br />
### E – Import Playbook <a name="iplaybook"></a>
### F – Docker Module <a name="docker"></a>



## I- Installation <a name="install"></a>

### A – Création d’une machine cloud ec2 (renaud-ec2-prod) <a name="ec2"></a>

3 machines AWS

* Ubuntu (renaud-ec2-master, renaud-ec2-worker01, renaud-ec2-worker02)
* EC2 : t3.medium, t2.micro (x2)
* 8 Go
* renaud-sg-ansible : 22 (ssh)
* key: renaud-kp-ajc.pem

![screenshot001](./images/IMG-001.png)
<br />

### B – Installation ansible <a name="ansible"></a>

* Via l'utilitaire pip

```sh
python3 --version
sudo apt-get -y update
sudo apt-get -y install python3-pip
sudo pip3 install ansible

ansible --version
```
<details>
<summary><code>résulat</code></summary>

```sh
ansible [core 2.12.1]
  config file = None
  configured module search path = ['/home/ubuntu/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.8/dist-packages/ansible
  ansible collection location = /home/ubuntu/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible
  python version = 3.8.10 (default, Nov 26 2021, 20:14:08) [GCC 9.3.0]
  jinja version = 2.10.1
  libyaml = True
```
</details>
<br />

* Via le gestionnaire de packets

```sh
#!/bin/bash
sudo apt-get update
sudo apt-get install ansible
sudo yum install ansible
```
<br />

## II- Manifest <a name="manifest"></a>

### A – Gestion de l'inventaire <a name="inventaire"></a>

* Création de l'inventaire

master: 172.31.6.38

worker01: 172.31.82.253

worker02: 172.31.93.193

```sh
vi hosts
```
<details>
<summary><code>hosts</code></summary>

```sh
172.31.82.253 ansible_user=ubuntu ansible_password=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```
</details>
<br />

* Test de ping vers worker01

```sh
ansible -i hosts all -m ping
```
<details>
<summary><code>résultat</code></summary>

```sh
172.31.82.253 | FAILED! => {
    "msg": "to use the 'ssh' connection type with passwords or pkcs11_provider, you must install the sshpass program"
}
```
</details>
<br />

* On doit installer sshpass pour les connexions ssh 

```sh
sudo apt-get -y install sshpass
ansible -i hosts all -m ping
```
<details>
<summary><code>résultat</code></summary>

```sh
172.31.82.253 | UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to connect to the host via ssh: Warning: Permanently added '172.31.82.253' (ECDSA) to the list of known hosts.\r\nubuntu@172.31.82.253: Permission denied (publickey).",
    "unreachable": true
}
```
</details>
<br />

* On doit activer l'authentification par password sur les clients

```sh
sudo vi /etc/ssh/sshd_config      =>  PasswordAuthentication yes
sudo systemctl restart ssh
sudo -i
passwd ubuntu

ansible -i hosts all -m ping
```
<details>
<summary><code>résultat</code></summary>

```sh
172.31.82.253 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
```
</details>
<br />

* Modification du hosts

```sh
vi hosts
```
<details>
<summary><code>hosts</code></summary>

```sh
worker01 ansible_host=172.31.82.253 ansible_user=ubuntu ansible_password=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```
</details>
<br />

```sh
ansible -i hosts all -m ping
```
<details>
<summary><code>résultat</code></summary>

```sh
worker01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```
</details>
<br />

### B – Module Copy <a name="copy"></a>
<br />

* Copie d'un fichier avec contenu
```sh
ansible -i hosts all -m copy -a "dest=/home/ubuntu/renaud.txt content='Bonjour Renaud'"
```
![screenshot002](./images/IMG-002.png)
<br />

### C – Module Package <a name="package"></a>

<br />

* Ajout du deuxième worker dans l'inventaire

```sh
vi hosts
```
<details>
<summary><code>host</code></summary>

```sh
worker01 ansible_host=172.31.82.253 ansible_user=ubuntu ansible_password=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no'
worker02 ansible_host=172.31.93.193 ansible_user=ubuntu ansible_password=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```
</details>
<br />

* Test de la connextion aux deux workers
```sh
ansible -i hosts all -m ping
```
<details>
<summary><code>résultat</code></summary>

```sh
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
```
</details>
<br />

* Installation du package nging sur les workers

```sh
ansible -i hosts -b -m package -a "name=nginx state=present" worker01
ansible -i hosts -b -m service -a "name=nginx state=started enabled=yes" worker01

ansible -i hosts -b -m package -a "name=apache2 state=present" worker02
ansible -i hosts -b -m service -a "name=apache2 state=started enabled=yes" worker02
```

On ouvre le port 80 du Security Group:
![screenshot003](./images/IMG-003.png)

<br />

* Désinstallation

```sh
ansible -i hosts -b -m package -a "name=nginx state=absent purge=yes autoremove=yes" worker01

ansible -i hosts -b -m package -a "name=apache2 state=absent purge=yes autoremove=yes" worker02
```
<br>

Vérification que le service ne tourne plus:
```sh
#worker01
ps -ef | grep nginx
#worker02
ps -ef | grep apache2
```
<br>

### D – Inventaire au format yaml <a name="yaml"></a>
<br>

* Création de l'inventaire au format yaml
```sh
vi hosts.yaml
```
<details>
<summary><code>hosts.yaml</code></summary>

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
</details>
<br />

* Test de la connaxion aux workers

```sh
ansible -i hosts.yaml -m ping all
```
<details>
<summary><code>résultat</code></summary>

```sh
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
```
</details>
<br />

### E – Module Setup <a name="setup"></a>
<br>

* Test du module Setup

```sh
ansible -i hosts.yaml all -m setup 
ansible -i hosts.yaml all -m setup | grep -i hostname
ansible -i hosts.yaml all -m setup | grep ansible_distribution
```
<br>

```sh
#Récupérartion des variables de nos environnement
ansible-inventory -i hosts.yaml --list
ansible-inventory -i hosts.yaml --host worker01
#Format yaml
ansible-inventory -i hosts.yaml --host worker01 -y
```
<br />

### F – Les formats de l'inventaire<a name="multi"></a>

<br>

* Création de l'inventaire au format ini 

```sh
vi hosts.ini
```
<details>
<summary><code>hosts.ini</code></summary>

```ini
[all:vars]
ansible_user=ubuntu
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[ansible]
localhost ansible_connection=local

[prod]
worker01 ansible_host=172.31.82.253 ansible_password=ubuntu
worker02 ansible_host=172.31.93.193 ansible_password=ubuntu

[prod:vars]
env=prod
```
</details>
<br />

* Convertion de l'inventaire aux différents formats

```sh
#Format yaml
ansible-inventory -i hosts.ini --list -y > hosts.yaml
#Format json
ansible-inventory -i hosts.ini --list > hosts.json
#test
ansible -i hosts.ini -m ping all
ansible -i hosts.yaml -m ping all
ansible -i hosts.json -m ping all
```
<br />

* Vérification 

```sh
vi host.yaml
```

<details>
<summary><code>hosts.yaml</code></summary>

```yaml
all:
  children:
    ansible:
      hosts:
        localhost:
          ansible_connection: local
          ansible_ssh_common_args: -o StrictHostKeyChecking=no
          ansible_user: ubuntu
    prod:
      hosts:
        worker01:
          ansible_host: 172.31.82.253
          ansible_password: ubuntu
          ansible_ssh_common_args: -o StrictHostKeyChecking=no
          ansible_user: ubuntu
          env: prod
        worker02:
          ansible_host: 172.31.93.193
          ansible_password: ubuntu
          ansible_ssh_common_args: -o StrictHostKeyChecking=no
          ansible_user: ubuntu
          env: prod
    ungrouped: {}
```
</details>
<br>


### G – Variables <a name="variable"></a>
<br>

* Affichage des variables avec le module Debug:


```sh
ansible -i hosts.yaml all -m debug -a "msg={{  env }} "
```

<details>
<summary><code>résultat</code></summary>

```sh
localhost | FAILED! => {
    "msg": "The task includes an option with an undefined variable. The error was: 'env' is undefined. 'env' is undefined"
}
worker01 | SUCCESS => {
    "msg": "prod"
}
worker02 | SUCCESS => {
    "msg": "prod"
}
```
</details>
<br/>

* Surcharge avec group_vars

```sh
mkdir group_vars
vi group_vars/prod.yaml        =>   env: test_prod

ansible -i hosts.ini all -m debug -a "msg={{  env }} "
```
<details>
<summary><code>résultat</code></summary>

```sh
localhost | FAILED! => {
    "msg": "The task includes an option with an undefined variable. The error was: 'env' is undefined. 'env' is undefined"
}
worker02 | SUCCESS => {
    "msg": "test_prod"
}
worker01 | SUCCESS => {
    "msg": "test_prod"
}

```
</details>
<br />

* Surcharge avec host_vars

```sh
mkdir host_vars

vi host_vars/worker01.yaml      =>   env: test_prod_W1

ansible -i hosts.ini all -m debug -a "msg={{  env }} "
```
<details>
<summary><code>résultat</code></summary>

```sh
localhost | FAILED! => {
    "msg": "The task includes an option with an undefined variable. The error was: 'env' is undefined. 'env' is undefined"
}
worker01 | SUCCESS => {
    "msg": "test_prod_W1"
}
worker02 | SUCCESS => {
    "msg": "test_prod"
}
```
</details>
<br>

```sh
vi host_vars/localhost.yaml         =>   env: test_prod_local

ansible -i hosts.ini all -m debug -a "msg={{  env }} "
```
<details>
<summary><code>résultat</code></summary>

```sh
localhost | SUCCESS => {
    "msg": "test_prod_local"
}
worker01 | SUCCESS => {
    "msg": "test_prod_W1"
}
worker02 | SUCCESS => {
    "msg": "test_prod"
}
```
</details>
<br />

* Surcharger en utilisant le parameter –e
```sh
ansible -i hosts.ini all -m debug -a "msg={{  env }} " -e env=surcharge
```
<details>
<summary><code>résultat</code></summary>

```sh
localhost | SUCCESS => {
    "msg": "surcharge"
}
worker02 | SUCCESS => {
    "msg": "surcharge"
}
worker01 | SUCCESS => {
    "msg": "surcharge"
}
```
<br>

## III- Playbook <a name="playbook"></a>

### A – Utilisation du playbook <a name="useplaybook"></a>
****
TP 8 (Déployez un serveur web)
****

```sh
#Install de l'outil de validation du playbook
sudo apt-get -y install ansible-lint

mkdir webapp
cd webapp/

vi prod.yaml
```
**prod.yaml**
```yaml
all:
  children:
    prod:
      vars:
        env: production
      hosts:
        worker01:
          ansible_host: 172.31.82.253
        worker02:
          ansible_host: 172.31.93.193
```

<br />

```sh
mkdir group_vars
vi group_vars/prod.yaml
```
**prod.yaml**
```yaml
env: prod
ansible_user: ubuntu
ansible_password: ubuntu
ansible_ssh_common_args: -o StrictHostKeyChecking=no
```
<br />

```sh
echo "Bonjour Renaud" > index.html

vi nginx.yaml
```
**nginx.yaml**
```yaml
- name: "install webserver"
  become: yes
  hosts: worker01
  pre_tasks:
    - name: "Test debug env var"
      debug:
        msg: "{{ env }}"
  tasks:
    - name: "install nginx"
      package:
        name: nginx
        state: present
    - name: "start nginx"
      service:
        name: nginx
        state: started
        enabled: yes
    - name: "copy file"
      copy:
        src: "index.html"
        dest: "/var/www/html"
```
<br />

```sh
ansible-playbook -i prod.yaml nginx.yaml

ansible-lint nginx.yaml
```
<br />

* Désinstallation du webserver

```sh
vi unnginx.yaml
```
**unnginx.yaml**
```yaml
- name: "uninstall webserver"
  become: yes
  hosts: prod
  tasks:
    - name: "Test debug env var"
      debug:
        msg: "{{ env }}"
    - name: "uninstall nginx"
      package: 
        name: nginx
        state: absent
        purge: yes
        autoremove: yes
```

### B – Templating Jinja <a name="jinja"></a>
****
TP 9 (Jinja) 
****

```sh
mkdir jinja
cd jinja

mkdir group_vars
vi group_vars/prod.yaml
```
**prod.yaml**
```yaml
env: prod
ansible_user: ubuntu
ansible_password: ubuntu
ansible_ssh_common_args: -o StrictHostKeyChecking=no
```
<br />

```sh
vi hosts.yaml
```
**hosts.yaml**
```yaml
all:
  children:
    prod:
      vars:
        env: production
      hosts:
        worker01:
          ansible_host: 172.31.82.253
        worker02:
          ansible_host: 172.31.93.193
```

<br />

```sh
mkdir template

vi template/install_nginx.sh.j2
```
**install_nginx.sh.j2**
```sh
#!/bin/bash
{% if ansible_distribution == "Ubuntu" -%}
apt-get -y install {{ app }}
{% elif ansible_distribution == "Centos" -%}
yum -y install {{ app }}
{% else -%}
{% endif %}
systemctl start {{ app }}
systemctl enable {{ app }}
```
<br />

```sh
vi nginx.yaml
```
**nginx.yaml**
```yaml
- name: "install webserver"
  become: yes
  vars:
    app: nginx
  hosts: prod
  pre_tasks:
    - name: "Test debug env var"
      debug:
        msg: "{{ env }}"
  tasks:
    - name: "Generate install_nginx"
      template:
        src: "./template/install_nginx.sh.j2"
        dest: "/home/{{ ansible_user }}/install_nginx.sh"
    - name: "Execute install_nginx"
      command:
        cmd: "sh /home/{{ ansible_user }}/install_nginx.sh"
```
```sh
ansible-playbook -i hosts.yaml nginx.yaml 
```
<br />

****
TP 10 (Jinja) 
****
* On créer le fichier uninstall_nginx.sh.j2
```sh
vi template/uninstall_nginx.sh.j2
```
**uninstall_nginx.sh.j2**
```sh
#!/bin/bash
{% if ansible_distribution == "Ubuntu" -%}
apt-get -y purge --autoremove {{ app }}
{% elif ansible_distribution == "Centos" -%}
yum -y purge --autoremove {{ app }}
{% else -%}
{% endif %}
```
<br />

* On créer le fichier unnginx.yaml

```sh
vi unnginx.yaml
```
**unnginx.yaml**
```yaml
- name: "uninstall webserver"
  become: yes
  vars:
    app: nginx
  hosts: worker02
  pre_tasks:
    - name: "Test debug env var"
      debug:
        msg: "{{ env }}"
  tasks:
    - name: "Generate uninstall_nginx"
      template:
        src: "./template/uninstall_nginx.sh.j2"
        dest: "/home/{{ ansible_user }}/uninstall_nginx.sh"
    - name: "Execute uninstall_nginx"
      command:
        cmd: "sh /home/{{ ansible_user }}/uninstall_nginx.sh"
```
```sh
ansible-playbook -i hosts.yaml unnginx.yaml 
```
<br />

****
TP 11 (Jinja) 
****

* Modification manuellement des noms de vos serveurs
```sh
sudo vi /etc/hosts
```
**hosts**
```sh
172.31.6.38 AnsibleMaster
172.31.82.253 AnsibleWorker01
172.31.93.193 AnsibleWorker02
```

vi /template/install_app.sh.j2
**install_app.sh.j2**
```sh
#!/bin/bash
{% if ansible_distribution == "Ubuntu" -%}
apt-get -y install {{ app }}
{% elif ansible_distribution == "Centos" -%}
yum -y install {{ app }}
{% else -%}
{% endif %}
```

```sh
vi webapp.yaml
```
<details>
<summary><code>webapp.yaml</code></summary>

```yaml
---
- name: "install webserver"
  become: yes
  vars:
    app: nginx
  hosts: prod
  pre_tasks:
    - name: "Test debug env var"
      debug:
        msg: "{{ env }}"
  tasks:
    - name: "Generate install_nginx"
      template:
        src: "./template/install_app.sh.j2"
        dest: "/home/{{ ansible_user }}/install_{{ app }}.sh"
    - name: "Execute install_nginx"
      command:
        cmd: "sh /home/{{ ansible_user }}/install_{{ app }}.sh"
    - name: "delete directory"
      file:
        path: "/var/www/html"
        state: absent
    - name: "create directory"
      file:
        path: "/var/www/html"
        state: directory
    - name: "Git clone"
      git:
        repo: 'https://github.com/diranetafen/static-website-example.git'
        dest: '/var/www/html'
    - name: "sed index.html"
      command:
        cmd: "sed -i 's/Dimension/Dimension : {{ ansible_hostname }}/' /var/www/html/index.html"
```
</details>
<br />


### C – When et loop <a name="when"></a>

****
TP 12 (When et loop) 
****
```sh
vi install.yaml
```

<details>
<summary><code>install.yaml</code></summary>

```yaml
---
- name: "install app"
  become: yes
  hosts: prod
  pre_tasks:
    - name: "Test debug env var"
      debug:
        msg: "{{ env }}"
  tasks:
    - name: "install app"
      apt:
        name: "{{ item }}"
        state: present
      when: ansible_distribution == "Ubuntu"
      loop:
        - nginx
        - git
```
</details>


### D – Include/Import et TAG <a name="include"></a>

****
TP 13A
****
```sh
vi install.yaml
```

<details>
<summary><code>install.yaml</code></summary>

```yaml
---
- name: "install app"
  apt:
    name: "{{ item }}"
    state: present
```
</details>

<br />

```sh
vi main.yaml
```

<details>
<summary><code>main.yaml</code></summary>

```yaml
---
- name: "install Nginx and Git"
  become: yes
  hosts: prod
  pre_tasks:
    - name: "Test debug env var"
      debug:
        msg: "{{ env }}"
  tasks:
    - include_tasks: /home/ubuntu/webapp/install.yaml
      when: ansible_distribution == "Ubuntu"
      with_items:
        - nginx
        - git
```
</details>

```sh
ansible-playbook -i prod.yaml main.yaml
```

### E – Import Playbook <a name="iplaybook"></a>

****
TP 13B (deploiement docker)
****
* Fichier d'inventaire
```sh
mkdir TP_mario

vi hosts.yaml
```

<details>
<summary><code>hosts.yaml</code></summary>

```yaml
all:
  children:
    prod:
      hosts:
        worker01:
          ansible_host: 172.31.82.253
          ansible_password: ubuntu
          ansible_ssh_common_args: -o StrictHostKeyChecking=no
          ansible_user: ubuntu
          env: prod
        worker02:
          ansible_host: 172.31.93.193
          ansible_password: ubuntu
          ansible_ssh_common_args: -o StrictHostKeyChecking=no
          ansible_user: ubuntu
          env: prod
```
</details>
<br />

* Fichier d'installation de Docker
```sh
vi docker.yaml
```

<details>
<summary><code>docker.yaml</code></summary>

```yaml
---
- name: "Install Docker"
  become: yes
  hosts: prod
  tasks:
    - name: "Download Install docker script"
      get_url:
        url: "https://get.docker.com"
        dest: /home/ubuntu/get-docker.sh
    - name: "launch docker"
      command: "sh /home/ubuntu/get-docker.sh"
    - name: "Give privilege to ubuntu"
      user:
        name: ubuntu
        append: yes
        groups:
          - docker
```
</details>
<br />

* Fichier de lancement du conteneur Mario
```sh
vi mario.yaml
```
<details>
<summary><code>mario.yaml</code></summary>

```yaml
---
- name: "Launch Mario Docker"
  become: yes
  hosts: prod
  tasks:
    - name: "Mario"
      command:
        cmd: "docker run -d -p 8600:8080 pengbai/docker-supermario"
```
</details>
<br />

* Fichier de deploiement de l'application Mario
```sh
vi deploy_mario.yaml
```

<details>
<summary><code>deploy_mario.yaml</code></summary>

```yaml
---
- name: "Install docker"
  import_playbook: docker.yaml

- name: "Deploy a mario container"
  import_playbook: mario.yaml
```
</details>
<br />

### F – Docker Module <a name="docker"></a>

* Installation du module docker manuel
```sh
sudo apt-get -y install python3-pip
sudo pip3 install docker-py
```
<br />>

* Installation du module docker par ansible
```sh
vi docker.yaml
```

<details>
<summary><code>docker.yaml</code></summary>

```yaml
---
- name: "Install Docker"
  become: yes
  hosts: prod
  tasks:
    - name: "Download Install docker script"
      get_url:
        url: "https://get.docker.com"
        dest: /home/ubuntu/get-docker.sh
    - name: "launch docker"
      command: "sh /home/ubuntu/get-docker.sh"
    - name: "Give privilege to ubuntu"
      user:
        name: ubuntu
        append: yes
        groups:
          - docker
    - name: install python pip
      apt:
        name: python3-pip
        state: present
      when: ansible_distribution == "Ubuntu"
    - name: install docker-py module
      pip:
        name: docker-py
        state: present
```
</details>
<br />

* Utilisation du module docker
****
TP 13B (module docker)
****

```sh
vi mario.yaml
```
<details>
<summary><code>mario.yaml</code></summary>

```yaml
---
- name: "Launch Mario Docker"
  hosts: prod
  become: true
  vars:
    ansible_sudo_pass: ubuntu

  tasks:
    - name: "create container mario"
      docker_container:
        name: mario
        image: pengbai/docker-supermario
        ports:
          - "8600:8080"
```
</details>


****
TP 14 (module docker)
****
```sh
mkdir webapp2
cd webapp2

vi hosts.yaml
```
<details>
<summary><code>hosts.yaml</code></summary>

```yaml
all:
  children:
    prod:
      hosts:
        worker01:
          ansible_host: 172.31.82.253
          ansible_password: ubuntu
          ansible_ssh_common_args: -o StrictHostKeyChecking=no
          ansible_user: ubuntu
          env: prod
        worker02:
          ansible_host: 172.31.93.193
          ansible_password: ubuntu
          ansible_ssh_common_args: -o StrictHostKeyChecking=no
          ansible_user: ubuntu
          env: prod
```
</details>
<br />

```sh
vi index.yaml
```
<details>
<summary><code>index.yaml</code></summary>

```yaml
- name: "Update index.html"
  become: yes
  hosts: prod
  tasks:
    - name: "create directory"
      file:
        path: "/tmp/html"
        state: directory
    - name: "Git clone"
      git:
        repo: 'https://github.com/diranetafen/static-website-example.git'
        dest: '/tmp/html'
        force: yes
    - name: "sed index.html"
      command:
        cmd: "sed -i 's/Dimension/Dimension : {{ ansible_hostname }}/' /tmp/html/index.html"
```
</details>
<br />

```sh
vi apache.yaml
```
<details>
<summary><code>apache.yaml</code></summary>

```yaml
---
- name: "install webserver"
  become: yes
  hosts: prod
  tasks:
    - name: "Create container apache"
      docker_container:
        name: apache
        image: httpd
        ports:
          - "8080:80"
        volumes:
          - "/tmp/html/:/usr/local/apache2/htdocs/"
```
</details>
<br />

```sh
 vi deploy_webserver.yaml
```

<details>
<summary><code>deploy_webserver.yaml</code></summary>

```yaml
---
- name: "Update index.html"
  import_playbook: index.yaml
  
- name: "Install Webservr"
  import_playbook: apache.yaml
```
</details>



CONNEXION SSH

vi reno_key.pem

chmod 400 reno_key.pem 

on rétire les user et password de hosts.yaml

```yaml
all:
  children:
    prod:
      hosts:
        worker01:
          ansible_host: 172.31.82.253
          env: prod
        worker02:
          ansible_host: 172.31.93.193
          env: prod
```

```sh
ansible -i hosts.yaml -m ping all
```
<details>
<summary><code>résultat</code></summary>

```sh
worker01 | UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to connect to the host via ssh: ubuntu@172.31.82.253: Permission denied (publickey,password).",
    "unreachable": true
}
worker02 | UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to connect to the host via ssh: ubuntu@172.31.93.193: Permission denied (publickey,password).",
    "unreachable": true
}
```
</details>
<br />

```sh
ansible -i hosts.yaml --private-key ../reno_key.pem -m ping all
```
<details>
<summary><code>résultat</code></summary>

```sh
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
```
</details>

OU dans le host:


```yaml
all:
  vars:
     ansible_ssh_private_key_file: /home/ubuntu/reno_key.pem
  children:
    prod:
      hosts:
        worker01:
          ansible_host: 172.31.82.253
          env: prod
        worker02:
          ansible_host: 172.31.93.193
          env: prod
```



## IV- Fichier de configuration <a name="config"></a>

```sh
vi ansible.cfg
```

<details>
<summary><code>ansible.cfg</code></summary>

```ini
[defaults]
inventory = /home/ubuntu/webapp2/hosts.yaml
ask_vault_pass = true

[privilege_escalation]
become = true
```
</details>

Plus besoin de préciser l'inventaire, le become=true

```sh
ansible --private-key ../reno_key.pem -m ping all
```

****
TP 15 (config et secret)
****


mkdir files
vi /files/secrets.yaml

ansible_vault_user: ubuntu
ansible_vault_password: ubuntu

 ansible-vault encrypt files/secrets.yaml

```sh
 vi hosts.yaml
```

```yaml
 all:
  vars:
   
  children:
    prod:
      hosts:
        worker01:
          ansible_host: 172.31.82.253
          ansible_user: "{{ ansible_vault_user }}"
          ansible_password: "{{ ansible_vault_password }}"
          env: prod
        worker02:
          ansible_host: 172.31.93.193
          ansible_user: "{{ ansible_vault_user }}"
          ansible_password: "{{ ansible_vault_password }}"
          env: prod
```


```sh
vi apache.yaml
```

```yaml
---
- name: "install webserver"
  hosts: prod
  vars_files:
    - files/secrets.yaml
  tasks:
    - name: "Create container apache"
      docker_container:
        name: apache
        image: httpd
        ports:
          - "8080:80"
        volumes:
          - "/tmp/html/:/usr/local/apache2/htdocs/"
```





***Delegate to***

vi host.yaml

```yaml
all:
  vars:
#     ansible_ssh_private_key_file: /home/ubuntu/frazer-kp-ajc1.pem
  children:
    ansible:
      hosts:
        localhost:
          ansible_connection: local
          ansible_user: ubuntu
          hostname: AnsibleMaster
    prod:
      vars:
        env: production
        ansible_user: ubuntu
        ansible_password: "ubuntu"
        ansible_ssh_common_args: '-o StrictHostKeyChecking=no'

      hosts:
        worker01:
          ansible_host: 172.31.95.37
          hostname: AnsibleWorker01
  
        worker02:
          ansible_host: 172.31.95.0
          hostname: AnsibleWorker02
```





vi test.yaml

```yaml
- name: "play to test delegate_to fonction"
  hosts: all
  become: true
  serial: 2
  tasks:
    - name: register of all hosts on master
      command: "sh -c 'echo {{ ansible_host }} {{ inventory_hostname }} >> /etc/hosts'"
      tags: name
      delegate_to: localhost

    - name: "test var "
      debug:
        var: ansible_play_hosts
```





## Rôle



AIDE

'''sh
git submodule add https://github.com/sadofrazer/odoo_role.git roles/odoo

ansible-galaxy role init <nom_du_role>


ansible_play_hosts




ROLE DL par galaxi

home/ubuntu/.ansible




## IV- Ansible Tower <a name="config"></a>

git clone https://github.com/sadofrazer/tower.git

t2.medium minimum
ubuntu
8go

ouverture du port 80

'''sh
#!/bin/bash
#Install docker
sudo apt-get update -y
sudo apt-get install git wget curl -y
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker ubuntu
#Install Docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
git clone https://github.com/sadofrazer/tower.git
cd tower/
tar -xzvf awx.tar.gz -C ~/
cd ~/.awx/awxcompose/
docker-compose up -d
'''


* Param tower

admin@password

hosts.yml
all:
  children:
    prod:
      hosts:
        worker01:
          ansible_host: 172.31.90.87
          ansible_ssh_common_args: -o StrictHostKeyChecking=no
  
        worker02:
          ansible_host: 172.31.86.63
          ansible_ssh_common_args: -o StrictHostKeyChecking=no


wordpress.yml
- name: deploy wordpress using a role
  hosts: all
  become: true
  roles:
    - docker_role
    - wordpress_role


roles/requirements.yml

- src: https://github.com/Renaud82/wordpress_role.git
- src: https://github.com/Renaud82/docker_role.git


* projet ->> new
type ->  GIT -> url

X mettre a jour revison au lancement


* inventaire
inventory_wordpress

source -> creer nouvelle source -> inventory_src_wordpress

provenance d'un fichier

fichier d'inventaire hosts.yml

synchroniser

* information d'identification

wordpress_vault
type coffre-fort

* modele

sipmle

wordpress_job

type -> executer

sélectrionner inventaire/projet/playbook



Création projet → nom:deploy_wordpress_project → details source → url du repo git deploy_wordpress → nom branche (master ou main) → options de mise a jour scm : mettre à jour révision au lancement (pour toujours récupérer la dernière version sur github lors du lancement du projet) → enregistrer 

Création inventaire → inventaire → + → inventaire (classique) → nom:inventory_wordpress → enregistrer → onglet sources → + → nom:inventory_src_wordpress → source:provenance d’un projet → repo public donc pas besoin de token → selection projet → selection fichier inventaire → hosts.yml (celui qui est à la racine du repo) → options de mise à jour scm : mettre à jour au lancement → enregistrer → cliquer sur synchronisation pour récupérer l'inventaire → onglet hôtes pour visualiser les hôtes → cliquer sur hôtes pour voir leurs variables → enregistrer → retour inventaire avec logos verts si ok

Création credentials → infos d'identification → + → nom:wordpress_vault → type:coffre-fort(vault) → organisation:default → motdepasse → enregistrer → + → nom:hosts_prod_id → type:machine → organisation:default → user:ubuntu → motdepasse:ubuntu (ou copie de clé privée en fonction du playbook) → methode d’escalade privilégiée:sudo → motdepasse:ubuntu → enregistré

Création job template → modèles → + →modèle de job → nom:deploy_wordpress_job → type:executer → inventaire:inventory_wordpress → projet:deploy_wordpress_project → playbook:wordpress.yml → info d’identification:host_prod_id et wordpress_vault → enregistrer → enregistrer

Modèle → icone fusée du deploy_wordpress_job pour lancer le job 


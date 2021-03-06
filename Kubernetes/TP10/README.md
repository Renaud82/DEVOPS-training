# Kubernetes-training / TP10
Création de deux deployments avec chacun 2 replicas de l’application kodekloud/webapp-color en rouge et en blue 
(cf. deploy-webapp-blue.yml et deploy-webapp-red.yml)
```sh
vi deploy-webapp-blue.yaml
kubectl apply -f deploy-webapp-blue.yaml 
vi deploy-webapp-red.yaml
kubectl apply -f deploy-webapp-red.yaml 
```
Création d'un service de type clusterIp pour exposer chaque deployement précédent (cf. service-webapp-blue.yaml et service-webapp-red.yaml)
```sh
vi service-webapp-blue.yaml
kubectl apply -f service-webapp-blue.yaml 
vi service-webapp-red.yaml
kubectl apply -f service-webapp-red.yaml 
```
Configuration d'une règle ingress permettant de consommer les deux applications comme suit:
- Host: www.renaud-webapp.com
- Path : /red et /blue (rouge et bleu étant les couleurs des différentes pages web obtenues)
```sh
vi webapp-ingress.yaml
kubectl apply -f webapp-ingress.yaml 
```
Vérification de la configuration de la règle
```sh
kubectl describe ingress nginx-rule
```
Modification du host
```sh
sudo vi /etc/hosts
On ajoute 127.0.0.1 www.renaud-webapp.com
```
Test du bon fonctionnement de la règle à l'aide d'un curl en local:
- Rouge
```sh
curl http://www.renaud-webapp.com/red
```
```html
<!doctype html>
<title>Hello from Flask</title>
<body style="background: #e74c3c;"></body>
<div style="color: #e4e4e4;
    text-align:  center;
    height: 90px;
    vertical-align:  middle;">

  <h1>Hello from rswebapp-red-sd55h!</h1>
</div>
```
- Bleu
```sh
curl http://www.renaud-webapp.com/blue
```
```html
<!doctype html>
<title>Hello from Flask</title>
<body style="background: #2980b9;"></body>
<div style="color: #e4e4e4;
    text-align:  center;
    height: 90px;
    vertical-align:  middle;">

  <h1>Hello from rswebapp-blue-glkgc!</h1>
 </div>
 ```

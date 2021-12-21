# Kubernetes-training / Mini-Projet
Création d'un manifest qui créer un namespace nommé production (cf. namespace-def.yaml)
```sh
vi namespace.yaml
```
```sh
kubectl apply -f namespace.yaml
```
Vérification
```sh
kubectl get ns
```
********************************
Création d'un manifest pour déployer un pod avec l’image kodekloud/webapp-color couleur rouge (cf. pod-red.yaml)
```sh
vi pod-red.yaml
```
Création d'un manifest pour déployer un pod avec l’image kodekloud/webapp-color couleur bleu (cf. pod-blue.yaml)
```sh
vi pod-blue.yaml
```
```sh
kubectl apply -f pod-red.yaml

kubectl apply -f pod-blue.yaml
```
Vérification
```sh
kubectl get -n production po
```
********************************
Création d'un manifest pour exposer les pods via un service de type node port

nodeport: 30008, targetport: 8080, label "app: web" (cf. service-nodeport-web.yaml)
```sh
vi service-nodeport-web.yaml

kubectl apply -f service-nodeport-web.yaml
```
Vérification
```sh
kubectl describe service web-service -n production
```

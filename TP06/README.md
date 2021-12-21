# Kubernetes-training / TP6

On créer le manifest (cf. pod.yaml)
```sh
vi pod.yaml
```
Lancement du manifest
```sh
kubectl apply -f pod.yaml
```
kubectl get po --show-labels

kubectl port-forward webapp-color 8080:8080 --address 0.0.0.0
****************************************

vi niginx-deployment.yaml

kubectl apply -f nginx-deployment.yaml 

kubectl get deploy --show-labels

kubectl get rs --show-labels

kubectl get po --show-labels

kubectl describe po rsnginx-c58f66c84-gbx6l
****************************************
vi niginx-deployment-latest.yaml

kubectl apply -f nginx-deployment-latest.yaml 

kubectl apply -f nginx-deployment-latest.yaml

kubectl get deploy --show-labels

kubectl get rs --show-labels

kubectl get po --show-labels

kubectl describe po rsnginx-85fdcb8f89-cls4w
****************************************

kubectl edit deploy rsnginx		-> permet de modifier certains paramètres directement

strategy:

&emsp;type: Recreate

OU

strategy:

&emsp;type: RollingUpdate
  
&emsp;rollingUpdate:
  
&emsp;&emsp;maxSurge: 1
    
&emsp;&emsp;maxUnavailable: 1 

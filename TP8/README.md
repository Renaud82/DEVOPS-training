# Kubernetes-training / TP8
```sh
kubectl get ns
```
```sh
vi namespace.yaml
```
```sh
kubectl apply -f namespace.yaml
```
```sh
kubectl get ns
```
********************************

vi pod-red.yaml

vi pod-blue.yaml

kubectl apply -f pod-red.yaml

kubectl apply -f pod-blue.yaml

kubectl get -n production po
********************************

vi service-nodeport-web.yaml

kubectl apply -f service-nodeport-web.yaml

kubectl describe service web-service -n production

# Kubernetes-training / TP8

kubectl get ns

vi namespace.yaml

kubectl apply -f namespace.yaml

kubectl get ns
********************************

vi pod-red.yaml

vi pod-blue.yaml

kubectl apply -f pod-red.yaml

kubectl apply -f pod-blue.yaml

kubectl get -n production po
********************************

vi service-nodeport-web.yaml

kubectl apply -f service-nodeport-web.yaml

# Kubernetes-training / TP07

vi webapp-configmap.yaml

kubectl apply -f webapp-configmap.yaml 

kubectl port-forward webapp-color-pod 8080:8080 --address 0.0.0.0

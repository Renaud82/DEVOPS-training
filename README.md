# Kubernetes-training

vi pod.yaml

kubectl apply -f pod.yaml

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

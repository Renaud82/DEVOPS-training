# Kubernetes-training / TP9
Création d'un manifest déployant un pod mysql, avec le dossier contenant la base de données monté sur le nœud dans /data-volume (cf. mysql-volume.yaml)
```sh
vi mysql-volume.yaml
kubectl apply -f mysql-volume.yaml 
```
On vérifie la création du répertoire associé au montage
```sh
ls /
```
*****************************
Création de deux manifests:
- volume persistent de taille 1 Go utilisant le dossier local /data-pv pour stocker les donneés (cf. pv.yaml)
- volume persistent claim de taille 100 Mo utilisant le PV créé précédement pour stocker les données (cf. pvc.yaml)
```sh
vi pv.yaml
vi pvc.yaml
kubectl apply -f pv.yaml 
kubectl apply -f pvc.yaml
```
Vérification
```sh
kubectl get pvc
kubectl get pv
```
Création d'un manifest déployant mysql mais le pod utilisera le volume de stockage le PVC créé précédemment (cf. mysql-volumepv.yaml)
```sh
vi mysql-volumepv.yaml
kubectl apply -f mysql-volumepv.yaml 
```
Vérification
```sh
ls /
kubectl describe po mysql-volume 
```

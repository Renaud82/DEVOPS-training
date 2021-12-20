# Storage
## Volumes
```yaml
spec:
  volumes:
  - name: data-volume
    hostPath:
      path: /data
      type: Directory  # also DirectoryOrCreate
```

## Persistent volumes
(No imperative command for creation)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-vol1
spec:
  accessModes:
  - ReadWriteOnce    # also possible: ReadOnlyMany, ReadWriteMany
  capacity:
    storage: 1Gi
  awsElasticBlockStore:
    volumeID: <volume-id>
    fsType: ext4
```

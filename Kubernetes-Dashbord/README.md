# 1、创建Token
```shell
https://headlamp.dev/docs/latest/installation/#create-a-service-account-token

1、
kubectl -n kube-system create serviceaccount headlamp-admin

2、
kubectl create clusterrolebinding headlamp-admin --serviceaccount=kube-system:headlamp-admin --clusterrole=cluster-admin


3、
kubectl create token headlamp-admin -n kube-system
```
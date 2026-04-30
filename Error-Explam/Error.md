问题一：
```shell
环境：预发环境
英文：Failed last sync attempt to [fff8e58fc4254612ce4d928ca84472cbdf5a64e3]: InvalidSpecError: Application referencing project default which does not exist
中文：上次同步尝试失败，目标目录为 [fff8e58fc4254612ce4d928ca84472cbdf5a64e3]：InvalidSpecError：应用程序引用了不存在的默认项目。
```



问题二：
```shell
环境：预发环境
英文：Failed to load live state: failed to get cluster info for "https://192.168.111.230:6443": error synchronizing cache state : failed to load open api schema while syncing cluster cache: error getting openapi resources: unexpected error when reading response body. Please retry. Original error: net/http: request canceled (Client.Timeout or context cancellation while reading body)
中文：加载实时状态失败：获取“https://192.168.111.230:6443”的集群信息失败：同步缓存状态时出错：同步集群缓存时加载 OpenAPI 模式失败：获取 OpenAPI 资源时出错：读取响应体时发生意外错误。请重试。原始错误：net/http：请求已取消（读取响应体时客户端超时或上下文取消）
```
排查步骤：
```shell
1、查看Kubernes上下文
root@master:~# kubectl config get-contexts
CURRENT   NAME                          CLUSTER           AUTHINFO           NAMESPACE
*         kubernetes-admin@kubernetes   kubernetes        kubernetes-admin   argocd
          prod                          prod-cluster      prod-user
          staging                       staging-cluster   staging-user


2、argpcd 集群查看
root@master:~# argocd cluster list
SERVER                          NAME        VERSION  STATUS   MESSAGE                                                                                                                                                                                                                                                         PROJECT
https://192.168.111.230:6443    staging     v1.34.6  Failed   failed to load open api schema while syncing cluster cache: error getting openapi resources: unexpected error when reading response body. Please retry. Original error: net/http: request canceled (Client.Timeout or context cancellation while reading body)
https://192.168.111.231:6443    prod                 Failed   failed to get server version: failed to get server version: Get "https://192.168.111.231:6443/version?timeout=32s": dial tcp 192.168.111.231:6443: connect: no route to host             
https://kubernetes.default.svc  in-cluster           Unknown  Cluster has no applications and is not being monitored.       

3、删除集群

root@master:~# argocd cluster  rm staging
Are you sure you want to remove 'staging'? Any Apps deploying to this cluster will go to health status Unknown.[y/n] y
Cluster 'staging' removed
{"level":"info","msg":"ClusterRoleBinding \"argocd-manager-role-binding\" deleted","time":"2026-04-30T01:50:02Z"}
{"level":"info","msg":"ClusterRole \"argocd-manager-role\" deleted","time":"2026-04-30T01:50:02Z"}
{"level":"info","msg":"ServiceAccount \"argocd-manager\" deleted","time":"2026-04-30T01:50:02Z"}
root@master:~# argocd cluster  rm prod
Are you sure you want to remove 'prod'? Any Apps deploying to this cluster will go to health status Unknown.[y/n] y
Cluster 'prod' removed
{"level":"info","msg":"ClusterRoleBinding \"argocd-manager-role-binding\" deleted","time":"2026-04-30T01:50:10Z"}
{"level":"info","msg":"ClusterRole \"argocd-manager-role\" deleted","time":"2026-04-30T01:50:10Z"}
{"level":"info","msg":"ServiceAccount \"argocd-manager\" deleted","time":"2026-04-30T01:50:10Z"}

4、重新加入集群
root@master:~# kubectl config get-contexts
CURRENT   NAME                          CLUSTER           AUTHINFO           NAMESPACE
*         kubernetes-admin@kubernetes   kubernetes        kubernetes-admin   argocd
          prod                          prod-cluster      prod-user
          staging                       staging-cluster   staging-user
root@master:~# argocd cluster add staging
WARNING: This will create a service account `argocd-manager` on the cluster referenced by context `staging` with full cluster level privileges. Do you want to continue [y/N]? y
{"level":"info","msg":"ServiceAccount \"argocd-manager\" created in namespace \"kube-system\"","time":"2026-04-30T01:51:41Z"}
{"level":"info","msg":"ClusterRole \"argocd-manager-role\" created","time":"2026-04-30T01:51:41Z"}
{"level":"info","msg":"ClusterRoleBinding \"argocd-manager-role-binding\" created","time":"2026-04-30T01:51:41Z"}
{"level":"info","msg":"Created bearer token secret \"argocd-manager-long-lived-token\" for ServiceAccount \"argocd-manager\"","time":"2026-04-30T01:51:41Z"}
Cluster 'https://192.168.111.230:6443' added
root@master:~# argocd cluster add prod
WARNING: This will create a service account `argocd-manager` on the cluster referenced by context `prod` with full cluster level privileges. Do you want to continue [y/N]? y
{"level":"info","msg":"ServiceAccount \"argocd-manager\" created in namespace \"kube-system\"","time":"2026-04-30T01:51:48Z"}
{"level":"info","msg":"ClusterRole \"argocd-manager-role\" created","time":"2026-04-30T01:51:48Z"}
{"level":"info","msg":"ClusterRoleBinding \"argocd-manager-role-binding\" created","time":"2026-04-30T01:51:48Z"}
{"level":"info","msg":"Created bearer token secret \"argocd-manager-long-lived-token\" for ServiceAccount \"argocd-manager\"","time":"2026-04-30T01:51:48Z"}
Cluster 'https://192.168.111.231:6443' added

root@master:~# argocd cluster list
SERVER                          NAME        VERSION  STATUS      MESSAGE                                                  PROJECT
https://192.168.111.231:6443    prod        v1.34.6  Successful
https://192.168.111.230:6443    staging     v1.34.6  Successful
https://kubernetes.default.svc  in-cluster           Unknown     Cluster has no applications and is not being monitored.
```


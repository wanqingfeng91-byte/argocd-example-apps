# 📘 Headlamp 访问 Token 创建指南（K3s / Kubernetes）

参考官方文档：
👉 https://headlamp.dev/docs/latest/installation/#create-a-service-account-token

---

## 🚀 一、创建 ServiceAccount

```bash
kubectl -n kube-system create serviceaccount headlamp-admin
```

---

## 🚀 二、绑定集群管理员权限（ClusterRoleBinding）

```bash
kubectl create clusterrolebinding headlamp-admin \
  --serviceaccount=kube-system:headlamp-admin \
  --clusterrole=cluster-admin
```

---

## ⚠️ 三、创建 Token（⚠️ 临时 Token）

```bash
kubectl create token headlamp-admin -n kube-system
```

### ❗ 注意

这种方式生成的 Token：

* ⏱ 默认有效期较短（通常 1 小时）
* 🔄 不会自动刷新
* ❌ 重启或过期后需要重新创建

👉 适用于：**临时登录测试，不适合长期使用**

---

# ✅ 推荐方案（长期可用）

## 🧱 四、创建永久 Token（Secret 方式）

创建 YAML 文件：

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: headlamp-admin-token
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: headlamp-admin
type: kubernetes.io/service-account-token
```

应用：

```bash
kubectl apply -f headlamp-token.yaml
```

---

## 🔑 五、获取 Token

```bash
kubectl get secret headlamp-admin-token -n kube-system \
  -o jsonpath="{.data.token}" | base64 -d
```

---

## 🎯 六、两种方式对比

| 方式                     | 类型       | 是否过期  | 适用场景 |
| ---------------------- | -------- | ----- | ---- |
| `kubectl create token` | 临时 Token | ✅ 会过期 | 临时测试 |
| Secret Token           | 长期 Token | ❌ 不过期 | ✅ 推荐 |

---

## 💡 七、最佳实践（强烈推荐）

对于 Headlamp：

👉 优先使用 **kubeconfig 登录**

```bash
cat ~/.kube/config
```

### 优点：

* 🔐 不依赖 Token
* ♻️ 不会频繁过期
* 🌐 支持多集群（适合 K3s 场景）
* 🧩 管理更方便

---

## 🧠 八、总结

* `kubectl create token` = **短期凭证（会过期）**
* Secret Token = **长期凭证（推荐）**
* kubeconfig = **最优解（生产推荐）**

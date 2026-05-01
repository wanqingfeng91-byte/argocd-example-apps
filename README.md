# 📘 argocd-example-apps

一个用于学习和实践 **Argo CD + Argo Rollouts + Kubernetes GitOps** 的示例仓库，包含多种部署方式（YAML / Helm / 混合模式）。

---

# 🧠 仓库用途

本仓库用于：

- 学习 Argo CD GitOps 工作流
- 实践 Argo Rollouts（金丝雀 / 蓝绿发布）
- 管理 Kubernetes 声明式部署
- 测试多种部署方式（YAML + Helm）
- 统一整理示例 / 工具 / 错误案例

---

# 📁 目录结构

```text
.
├─argo-rollouts/              # Argo Rollouts 策略与示例
├─argocd-applications/        # Argo CD Application 定义
│
├─argocd-manifest/            # 应用 Kubernetes 资源
│  ├─argocd-geo-deployment/   # 原生 YAML Deployment 示例
│  └─argocd-geo-helm/         # Helm 示例应用
│
├─Error-Explam/               # ❌ 错误案例 / 学习用错误配置
│
├─other-tools/                # 工具 & 示例应用
│  ├─Kubernetes-Dashbord/     # Kubernetes Dashboard 示例
│  └─my-python-app/           # Python 示例应用
│
└─.idea/                      # IDE 配置（可忽略）
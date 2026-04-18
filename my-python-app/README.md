# Argo CD Learning Demo: Python Geo-Location App

本项目的核心目标是作为 **Argo CD Application 资源字段** 的实战载体。通过一个带有地理位置感知的 Python 应用，模拟企业级发布中的环境配置、健康检查及灰度感知。

---

## 🛠 一、 技术栈清单 (Technical Stack)

| 维度 | 技术选型 | 说明 |
| :--- | :--- | :--- |
| **应用开发** | `Python 3.9` + `Flask` | 轻量级 Web 框架，便于演示业务逻辑 |
| **容器技术** | `Docker` + `Alpine Linux` | 极致精简镜像，生产级非 root 权限运行 |
| **辅助构建** | `Pillow (PIL)` | 动态生成 favicon 图标，解决浏览器 404 日志干扰 |
| **地理感知** | `ip-api.com` (Rest API) | 模拟微服务外部调用，验证容器出口网络连通性 |
| **基础设施** | `K3s` + `Argo CD` | 实现轻量化多集群 GitOps 闭环 |

---

## 🛠 二、 构建方案 (Build Strategy)

本项目采用 **“自动化像素构建”** 方案，所有的静态资源（图标）均在构建阶段生成，确保镜像的纯净与解耦。

### 1. 镜像构建流程

1. **依赖预装**：基于 Alpine 安装构建工具链。
2. **图标合成**：利用 Python 脚本在容器内动态绘制 `favicon.ico`。
3. **安全加固**：创建 `argouser` 用户，通过 `USER` 指令剥夺 root 权限。
4. **环境变量预设**：定义默认 `APP_LANG` 和 `ENV_NAME`。

### 2. 命令行执行
```bash
# 构建 v1.4.0 版本
docker build --network host -t <your-hub-user>/argocd-geo-demo:v1.0 .

# 推送至 Docker Hub
docker push <your-hub-user>/argo-demo:v1.4.0
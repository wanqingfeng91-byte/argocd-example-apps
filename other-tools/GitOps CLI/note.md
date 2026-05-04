# GitOps CLI（argocd）参考

Red Hat OpenShift GitOps 1.12  
配置 GitOps CLI 并在默认模式下登录到 Argo CD 服务器  
Red Hat OpenShift Documentation Team  

---

## 法律通告

### 摘要

本文档提供有关如何配置 GitOps CLI 并以默认模式登录到 Argo CD 服务器的信息。它还讨论了基本的 GitOps `argocd` 命令。

---

# 第 1 章 配置 GitOps CLI

> 重要  
Red Hat OpenShift GitOps `argocd` CLI 工具只是一个技术预览功能。技术预览功能不受红帽产品服务等级协议（SLA）支持，且功能可能并不完整。红帽不推荐在生产环境中使用它们。这些技术预览功能可以使用户提早试用新的功能，并有机会在开发阶段提供反馈意见。  

有关红帽技术预览功能支持范围的更多信息，请参阅技术预览功能支持范围。

---

## 1.1 启用 Tab 自动补全功能

安装 GitOps `argocd` CLI 后，可以启用 Tab 自动补全功能，以便在按 Tab 键时自动补全 `argocd` 命令或提示可选项。

> 注意：Tab 补全仅支持 Bash shell。

---

## 先决条件

- 已安装 GitOps `argocd` CLI 工具  
- 本地系统已安装 `bash-completion`

---

## 配置流程（Bash）

### 1. 生成补全脚本

```bash
argocd completion bash > argocd_bash_completion
```

### 2. 复制到系统目录
```shell
sudo cp argocd_bash_completion /etc/bash_completion.d/
```

### 或者（可选方式）
你也可以将文件保存到本地目录，并在 ~/.bash_profile 中加载：
```shell
source /path/to/argocd_bash_completion
```

### 生效方式
重新打开一个终端后，Tab 自动补全功能即可生效。
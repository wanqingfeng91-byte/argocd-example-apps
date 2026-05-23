#!/usr/bin/env bash

set -e

VERSION="v1.9.0"

echo "🚀 Installing Argo Rollouts ${VERSION}"

# =========================
# Detect Arch
# =========================

ARCH=$(uname -m)

case $ARCH in
    x86_64)
        BIN_ARCH="amd64"
        ;;
    aarch64|arm64)
        BIN_ARCH="arm64"
        ;;
    *)
        echo "❌ Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "✅ Architecture: ${BIN_ARCH}"

# =========================
# Install Argo Rollouts Controller
# =========================

echo "📦 Installing Argo Rollouts Controller..."

kubectl create namespace argo-rollouts --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -n argo-rollouts \
  -f https://github.com/argoproj/argo-rollouts/releases/download/${VERSION}/install.yaml

echo "⏳ Waiting for controller..."

kubectl rollout status deployment/argo-rollouts \
  -n argo-rollouts \
  --timeout=180s

# =========================
# Install kubectl plugin
# =========================

echo "📦 Installing kubectl argo rollouts plugin..."

curl -LO \
https://github.com/argoproj/argo-rollouts/releases/download/${VERSION}/kubectl-argo-rollouts-linux-${BIN_ARCH}

chmod +x kubectl-argo-rollouts-linux-${BIN_ARCH}

mv kubectl-argo-rollouts-linux-${BIN_ARCH} \
/usr/local/bin/kubectl-argo-rollouts

# =========================
# Verify
# =========================

echo ""
echo "✅ Installed Successfully"
echo ""

kubectl argo rollouts version

echo ""
echo "📊 Current Rollouts Pods:"
kubectl get pods -n argo-rollouts

echo ""
echo "🌐 Starting Dashboard..."
echo "👉 Access: http://localhost:3100"
echo ""

kubectl argo rollouts dashboard
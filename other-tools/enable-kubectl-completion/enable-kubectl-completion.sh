#!/usr/bin/env bash

set -e

echo "🚀 开始配置 kubectl 自动补全..."

# 检查 kubectl
if ! command -v kubectl >/dev/null 2>&1; then
    echo "❌ 未检测到 kubectl，请先安装 kubectl"
    exit 1
fi

SHELL_NAME=$(basename "$SHELL")

echo "📦 当前 Shell: $SHELL_NAME"

# =========================
# Bash
# =========================
setup_bash() {

    echo "🔧 配置 Bash 自动补全..."

    # macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then

        if command -v brew >/dev/null 2>&1; then

            BASH_VERSION_MAJOR=$(bash --version | head -1 | grep -oE '[0-9]+' | head -1)

            if [[ "$BASH_VERSION_MAJOR" -ge 4 ]]; then
                brew install bash-completion@2
            else
                brew install bash-completion
            fi

            mkdir -p "$(brew --prefix)/etc/bash_completion.d"

            kubectl completion bash > "$(brew --prefix)/etc/bash_completion.d/kubectl"
        fi
    fi

    # Linux
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then

        if command -v apt >/dev/null 2>&1; then
            sudo apt update
            sudo apt install -y bash-completion
        elif command -v yum >/dev/null 2>&1; then
            sudo yum install -y bash-completion
        fi
    fi

    mkdir -p ~/.kube

    kubectl completion bash > ~/.kube/completion.bash.inc

    if ! grep -q "completion.bash.inc" ~/.bashrc 2>/dev/null; then
        cat <<EOF >> ~/.bashrc

# kubectl completion
source \$HOME/.kube/completion.bash.inc
EOF
    fi

    if ! grep -q "completion.bash.inc" ~/.bash_profile 2>/dev/null; then
        cat <<EOF >> ~/.bash_profile

# kubectl completion
source \$HOME/.kube/completion.bash.inc
EOF
    fi

    source ~/.bashrc || true
    source ~/.bash_profile || true

    echo "✅ Bash kubectl 自动补全已永久生效"
}

# =========================
# Zsh
# =========================
setup_zsh() {

    echo "🔧 配置 Zsh 自动补全..."

    mkdir -p ~/.zsh/completion

    kubectl completion zsh > ~/.zsh/completion/_kubectl

    if ! grep -q "fpath=(~/.zsh/completion" ~/.zshrc 2>/dev/null; then
        cat <<EOF >> ~/.zshrc

# kubectl completion
fpath=(~/.zsh/completion \$fpath)
autoload -Uz compinit
compinit
EOF
    fi

    source ~/.zshrc || true

    echo "✅ Zsh kubectl 自动补全已永久生效"
}

# =========================
# Fish
# =========================
setup_fish() {

    echo "🔧 配置 Fish 自动补全..."

    mkdir -p ~/.config/fish/completions

    kubectl completion fish > ~/.config/fish/completions/kubectl.fish

    echo "✅ Fish kubectl 自动补全已永久生效"
}

# =========================
# 执行
# =========================

case "$SHELL_NAME" in
    bash)
        setup_bash
        ;;
    zsh)
        setup_zsh
        ;;
    fish)
        setup_fish
        ;;
    *)
        echo "⚠️ 当前 Shell 不在支持列表中: $SHELL_NAME"
        ;;
esac

echo ""
echo "🎉 配置完成"
echo "👉 重新打开终端即可使用 kubectl 自动补全"
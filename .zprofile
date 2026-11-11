# ==============================================================================
# .zprofile - ログインシェル設定
# ==============================================================================

# Homebrew (Apple Silicon / Intel Mac 両対応)
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
fi

# ユーザーローカルバイナリ (~/.local/bin)
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

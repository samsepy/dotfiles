# ==============================================================================
# .zshrc - インタラクティブシェル設定
# ==============================================================================

# ------------------------------------------------------------------------------
# 基本環境変数・PATH初期化
# ------------------------------------------------------------------------------
export LANG=ja_JP.UTF-8
export EDITOR=vim

# PATHの重複を自動除去
typeset -U path PATH

# Homebrew (非ログインシェルで .zprofile が未読込の場合のフォールバック)
if [[ -z "${HOMEBREW_PREFIX}" ]]; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# ------------------------------------------------------------------------------
# ヒストリ設定
# ------------------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

# ------------------------------------------------------------------------------
# シェルオプション・単語区切り
# ------------------------------------------------------------------------------
# 単語区切り文字の定義 ('/' も区切りとみなし ^W で1階層ずつ削除可能にする)
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

setopt print_eight_bit       # 日本語ファイル名を表示可能にする
setopt no_beep               # ビープ音を無効化する
setopt no_flow_control       # フローコントロール (Ctrl+S/Ctrl+Q) を無効化する
setopt ignore_eof            # Ctrl+D でシェルを終了しない
setopt interactive_comments  # コマンドラインでも '#' 以降をコメントとして扱う
setopt auto_cd               # ディレクトリ名のみで cd する
setopt auto_pushd            # cd 時に自動でディレクトリスタックへ追加する
setopt pushd_ignore_dups     # 重複したディレクトリをスタックに追加しない
setopt share_history         # 複数ターミナル間でヒストリをリアルタイム共有する
setopt hist_ignore_all_dups  # 重複するコマンドは古い方を削除する
setopt hist_ignore_space     # スペース始まりのコマンドはヒストリに残さない
setopt hist_reduce_blanks    # ヒストリ保存時に余分なスペースを詰める
setopt extended_glob         # 高機能なワイルドカード展開を有効化する
setopt nonomatch             # glob が一致しない場合のエラーを抑止する

# ------------------------------------------------------------------------------
# 補完設定 (日次キャッシュによる高速化)
# ------------------------------------------------------------------------------
autoload -Uz compinit
if [[ -n "$HOME/.zcompdump"(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# 小文字入力でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# '../' の後はカレントディレクトリを補完候補に出さない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path \
    /opt/homebrew/sbin /opt/homebrew/bin \
    /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin /sbin /bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# ------------------------------------------------------------------------------
# キーバインド・ファジー検索連携
# ------------------------------------------------------------------------------
# ^R でワイルドカード対応の履歴インクリメンタル検索
bindkey '^R' history-incremental-pattern-search-backward
# ^J のデフォルトバインドを解除
bindkey -r '^J'

# ghq + fzf でリポジトリに素早く移動 (^G)
if (( $+commands[ghq] && $+commands[fzf] )); then
    function _ghq_fzf_cd() {
        local dir
        dir="$(ghq list -p | fzf --reverse --height=40%)"
        if [[ -n "$dir" ]]; then
            BUFFER="cd ${(q)dir}"
            zle accept-line
        fi
        zle reset-prompt
    }
    zle -N _ghq_fzf_cd
    bindkey '^G' _ghq_fzf_cd
fi

# ------------------------------------------------------------------------------
# エイリアス
# ------------------------------------------------------------------------------
alias la='ls -a'
alias ll='ls -l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias o='open'
alias mkdir='mkdir -p'

# sudo の後のコマンドでもエイリアスを有効化する
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# 標準出力をクリップボードへコピーするグローバルエイリアス (Mac / Linux / Cygwin 対応)
if (( $+commands[pbcopy] )); then
    alias -g C='| pbcopy'
elif (( $+commands[xsel] )); then
    alias -g C='| xsel --input --clipboard'
elif (( $+commands[putclip] )); then
    alias -g C='| putclip'
fi

# ユーティリティエイリアス
alias hc='rm -f ~/.zsh_history && re'
alias re='exec -l $SHELL'
alias bl='brew update && brew upgrade && brew cleanup'
alias dt='date "+%Y-%m-%d"'

# Apple Silicon / Rosetta アーキテクチャ切替
if (( $+commands[arch] )) && [[ "$(uname -s)" == "Darwin" ]]; then
    alias a64="exec arch -arch arm64e '$SHELL'"
    alias x64="exec arch -arch x86_64 '$SHELL'"
fi

# OS別の ls カラー設定
case "${OSTYPE}" in
    darwin*)
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        alias ls='ls -F --color=auto'
        ;;
esac

# ------------------------------------------------------------------------------
# 各種ツール・言語ランタイム (存在する環境のみ有効化)
# ------------------------------------------------------------------------------
# ユーザーローカルバイナリ・エディタCLI
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/.antigravity/antigravity/bin" ]] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
[[ -d "$HOME/.codeium/windsurf/bin" ]] && export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# Homebrew keg-only パッケージ
if [[ -n "${HOMEBREW_PREFIX}" ]]; then
    [[ -d "${HOMEBREW_PREFIX}/opt/postgresql@14/bin" ]] && export PATH="${HOMEBREW_PREFIX}/opt/postgresql@14/bin:$PATH"
    [[ -d "${HOMEBREW_PREFIX}/opt/mysql-client/bin" ]] && export PATH="${HOMEBREW_PREFIX}/opt/mysql-client/bin:$PATH"
    [[ -d "${HOMEBREW_PREFIX}/lib" ]] && export LIBRARY_PATH="${LIBRARY_PATH:+${LIBRARY_PATH}:}${HOMEBREW_PREFIX}/lib"
fi

# anyenv (起動高速化のため --no-rehash を指定)
if [[ -d "$HOME/.anyenv" ]]; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init - --no-rehash)"
    [[ -d "$HOME/.anyenv/envs/rbenv/shims" ]] && export PATH="$HOME/.anyenv/envs/rbenv/shims:$PATH"
fi
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# direnv
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

# Yarn
[[ -d "$HOME/.yarn/bin" ]] && export PATH="$HOME/.yarn/bin:$PATH"

# Bun
if [[ -d "$HOME/.bun" ]]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    [[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"
fi

# Pulumi
[[ -d "$HOME/.pulumi/bin" ]] && export PATH="$PATH:$HOME/.pulumi/bin"

# Google Cloud SDK
[[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/google-cloud-sdk/completion.zsh.inc"

# Claude Code 切替エイリアス (AWSプロファイル等は ~/.zshrc.local で上書き可能)
alias claude-sub="CLAUDE_CODE_USE_BEDROCK=0 CLAUDE_CONFIG_DIR=$HOME/.claude-main claude"
alias claude-bedrock='CLAUDE_CODE_USE_BEDROCK=1 AWS_REGION="${CLAUDE_BEDROCK_AWS_REGION:-ap-northeast-1}" AWS_PROFILE="${CLAUDE_BEDROCK_AWS_PROFILE}" CLAUDE_CONFIG_DIR="$HOME/.claude-bedrock" claude'

# ------------------------------------------------------------------------------
# プロンプト (Starship があれば優先、なければ標準の2行プロンプト + vcs_info)
# ------------------------------------------------------------------------------
if (( $+commands[starship] )) && [[ "${TERM}" != "dumb" ]]; then
    eval "$(starship init zsh)"
else
    autoload -Uz colors && colors
    PROMPT="%{${fg[green]}%}%~%{${reset_color}%}
%# "
    autoload -Uz vcs_info
    autoload -Uz add-zsh-hook
    zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
    zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'
    function _update_vcs_info_msg() {
        LANG=en_US.UTF-8 vcs_info
        RPROMPT="${vcs_info_msg_0_}"
    }
    add-zsh-hook precmd _update_vcs_info_msg
fi

# ------------------------------------------------------------------------------
# Zsh プラグイン (入力補完・構文ハイライト - インストール済み環境のみ有効化)
# ------------------------------------------------------------------------------
if [[ -n "${HOMEBREW_PREFIX}" ]]; then
    [[ -f "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
        source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [[ -f "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
        source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ------------------------------------------------------------------------------
# マシン固有設定の読み込み (Git管理外)
# ------------------------------------------------------------------------------
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# SDKMAN (仕様上ファイルの末尾付近で読み込む)
if [[ -d "$HOME/.sdkman" ]]; then
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# vim:set ft=zsh:

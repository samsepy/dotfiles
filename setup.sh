#!/usr/bin/env bash
# ==============================================================================
# setup.sh - dotfiles シンボリックリンク作成スクリプト
# ==============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ホームディレクトリ配下にリンクする対象ファイル・ディレクトリ一覧
DOT_FILES=(
    .zshrc
    .zprofile
    .vimrc
    .vim
    .tmux.conf
    .gitconfig
    .config/git/ignore
)

for file in "${DOT_FILES[@]}"; do
    src="${DOTFILES_DIR}/${file}"
    dest="${HOME}/${file}"

    mkdir -p "$(dirname "${dest}")"

    # シンボリックリンクではない実ファイルが既に存在する場合はバックアップを作成
    if [[ -e "${dest}" && ! -L "${dest}" ]]; then
        echo "Backing up existing ${dest} -> ${dest}.backup"
        mv "${dest}" "${dest}.backup"
    fi

    ln -snfv "${src}" "${dest}"
done

echo "dotfiles setup completed!"

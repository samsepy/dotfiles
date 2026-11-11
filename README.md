# dotfiles

環境に依存せず、複数のマシンで共通して利用できる設定ファイル群です。

## 構成

| ファイル / ディレクトリ | 説明 |
| :--- | :--- |
| [`.zprofile`](./.zprofile) | ログインシェル設定（Homebrew・`~/.local/bin` の初期化） |
| [`.zshrc`](./.zshrc) | Zsh インタラクティブシェル設定（プロンプト・補完・エイリアス・各種ツール連携） |
| [`.vimrc`](./.vimrc) / [`.vim/`](./.vim) | Vim 基本設定および `dein.vim` プラグイン定義 |
| [`.tmux.conf`](./.tmux.conf) | Tmux 設定（`Ctrl+a` プレフィックス、Molokai カラースキーム） |
| [`.gitconfig`](./.gitconfig) | Git 共通設定 |
| [`.config/git/ignore`](./.config/git/ignore) | グローバル Git Ignore 設定 |
| [`Brewfile`](./Brewfile) | Homebrew パッケージ・Cask・VS Code 拡張の一覧 |
| [`setup.sh`](./setup.sh) | シンボリックリンク一括作成スクリプト |

## セットアップ手順

### 1. シンボリックリンクの作成

```bash
git clone <repository-url> ~/dotfiles
cd ~/dotfiles
./setup.sh
```

既存の実ファイルがある場合は自動的に `*.backup` として退避した上でシンボリックリンクを作成します。

### 2. Homebrew パッケージの一括インストール（任意）

```bash
brew bundle --file=~/dotfiles/Brewfile
```

## マシン固有設定の分離（Git 管理外）

特定のマシンや業務環境に依存する設定（AWS アカウント ID、業務用の Git メールアドレスや GPG キー等）は、以下のローカルファイルに記述することで自動的に読み込まれます。

- **Zsh**: `~/.zshrc.local`
  ```zsh
  export CLAUDE_BEDROCK_AWS_REGION="ap-northeast-1"
  export CLAUDE_BEDROCK_AWS_PROFILE="your-aws-profile"
  ```
- **Git**: `~/.gitconfig.local`
  ```ini
  [user]
      email = work@example.com
      signingkey = YOUR_GPG_KEY
  ```
- **Tmux**: `~/.tmux.conf.local`

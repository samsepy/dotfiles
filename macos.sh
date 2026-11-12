#!/usr/bin/env bash
# ==============================================================================
# macos.sh - macOS システム環境設定スクリプト
# ==============================================================================
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Skipping macOS defaults: not running on macOS."
    exit 0
fi

echo "Applying macOS system preferences..."

# 設定変更前にシステム設定アプリを終了
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# ------------------------------------------------------------------------------
# キーボード・入力設定
# ------------------------------------------------------------------------------
# キーリピート開始までの時間とリピート速度を高速化
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2

# キー長押しで特殊文字ポップアップではなくキーリピートを有効化
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# 自動大文字変換・スマート引用符・スマートダッシュを無効化 (コーディング時の誤変換防止)
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# ------------------------------------------------------------------------------
# Finder 設定
# ------------------------------------------------------------------------------
# すべてのファイル拡張子を常に表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# パスバーとステータスバーを下部に表示
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# 検索時のデフォルトスコープを「現在のフォルダ」に設定
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# 拡張子変更時の警告ダイアログを無効化
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# ネットワークボリュームやUSBストレージに .DS_Store を作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ------------------------------------------------------------------------------
# Dock 設定
# ------------------------------------------------------------------------------
# アイコンサイズを 56px に設定
defaults write com.apple.dock tilesize -int 56

# 最近使ったアプリを Dock に表示しない
defaults write com.apple.dock show-recents -bool false

# ------------------------------------------------------------------------------
# 対象アプリケーションの再起動
# ------------------------------------------------------------------------------
for app in "Finder" "Dock"; do
    killall "${app}" >/dev/null 2>&1 || true
done

echo "macOS system preferences applied!"

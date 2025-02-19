#!/bin/bash

# 作業ディレクトリを取得
TARGET_DIR=$(pwd)

echo "📂 AIコミットチェックを適用するディレクトリ: $TARGET_DIR"

# `git-commit-ai-checker` をクローン
echo "🚀 git-commit-ai-checker をクローン中..."
git clone https://github.com/Taiga0824js/git-commit-ai-checker.git

# `install.sh` をコピー
echo "📂 install.sh を $TARGET_DIR にコピー..."
cp git-commit-ai-checker/install.sh $TARGET_DIR

# `git-commit-ai-checker` を削除（不要なため）
echo "🧹 git-commit-ai-checker を削除..."
rm -rf git-commit-ai-checker

# `install.sh` を実行
echo "⚙️ install.sh を実行..."
bash install.sh

echo "🎉 AIコミットチェックの導入完了！"


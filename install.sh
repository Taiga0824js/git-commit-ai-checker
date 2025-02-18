#!/bin/bash

# 1. Husky のインストール
echo "📦 Husky をインストール中..."
npm install husky --save-dev

# 2. OpenAI API クライアントをインストール
echo "🤖 OpenAI API クライアントをインストール中..."
npm install openai dotenv

# 3. Husky をセットアップ
echo "🔧 Husky のセットアップ..."
npx husky-init
npm install

# 4. commit-msg フックを設定
echo "⚙️ commit-msg フックを追加..."
npx husky set .husky/commit-msg "node scripts/check-commit.js \"\$1\""
chmod +x .husky/commit-msg

# 5. スクリプトディレクトリを作成
mkdir -p scripts

# 6. check-commit.js を作成
echo "📝 check-commit.js を作成..."
cat <<EOL > scripts/check-commit.js
import fs from "fs";
import dotenv from "dotenv";
import OpenAI from "openai";

dotenv.config();

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

const commitMsgFile = process.argv[2];
if (!commitMsgFile) {
    console.error("🚨 エラー: コミットメッセージのファイルパスが渡されていません！");
    process.exit(1);
}

const commitMessage = fs.readFileSync(commitMsgFile, "utf8").trim();

console.log(\`🔍 AIに判定依頼: 「\${commitMessage}」\`);

const response = await openai.chat.completions.create({
    model: "gpt-4-turbo",
    messages: [
        { role: "system", content: "あなたはGitのコミットメッセージを評価するAIです。適切なら「OK」、不適切なら「NG」とだけ返答してください。" },
        { role: "user", content: \`このコミットメッセージは適切ですか？: "\${commitMessage}"\` }
    ]
});

const aiDecision = response.choices[0].message.content.trim();

if (aiDecision === "NG") {
    console.error("🚨 AI判定: コミットメッセージが不適切です！やり直してください。");
    process.exit(1);
}

console.log("✅ AI判定: コミットメッセージOK！");
process.exit(0);
EOL

chmod +x scripts/check-commit.js

# 7. 環境変数のセットアップ
echo "🔑 .env ファイルを作成（APIキーを設定してください）"
echo "OPENAI_API_KEY=your-api-key-here" > .env

echo "🎉 設定完了！.env に APIキーを設定してから使用してください。"

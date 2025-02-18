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

console.log(`🔍 AIに判定依頼: 「${commitMessage}」`);

// OpenAI API でメッセージの適切さを判定
const response = await openai.chat.completions.create({
    model: "gpt-4-turbo",
    messages: [
        { role: "system", content: "あなたはGitのコミットメッセージを評価するAIです。適切なら「OK」、不適切なら「NG」とだけ返答してください。また、理由を一文だけ述べてください。" },
        { role: "user", content: `このコミットメッセージは適切ですか？: "${commitMessage}"` }
    ]
});

// AIの返答を取得
const aiResponse = response.choices[0].message.content.trim();

// 「OK」か「NG」で分岐
if (aiResponse.startsWith("NG")) {
    const reason = aiResponse.replace("NG", "").trim();
    console.error(`🚨 AI判定: コミットメッセージが不適切です！理由: ${reason}`);
    process.exit(1); // コミットを中止
}

console.log("✅ AI判定: コミットメッセージOK！");
process.exit(0);

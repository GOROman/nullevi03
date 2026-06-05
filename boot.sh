#!/bin/sh


# Discord Bot Token (プラグインが Discord に接続するために使用)
DISCORD_BOT_TOKEN="${DISCORD_BOT_TOKEN:-MTIzxxxxxxxxxxxxxxxxxxxxx.xxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx}"

# Discord Webhook URL (起動・再起動の通知をチャンネルにプッシュするために使用)
DISCORD_WEBHOOK_URL="${DISCORD_WEBHOOK_URL:-https://discord.com/api/webhooks/000000000000000000/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx}"

# プラグイン (MCP サーバ) が参照する環境変数として export
export DISCORD_BOT_TOKEN

notify_discord() {
  text="$1"
  if [ -n "$DISCORD_WEBHOOK_URL" ]; then
    curl -s -X POST "$DISCORD_WEBHOOK_URL" \
      -H "Content-Type: application/json" \
      -d "{\"content\":\"${text}\"}" \
      > /dev/null 2>&1 || true
  fi
}

FIRST=1
while true; do
  if [ "$FIRST" = "1" ]; then
    notify_discord "🦐 boot.sh起動: ナルエビ三世を起動します🌅"
    FIRST=0
  else
    notify_discord "🦐 ナルエビ三世が終了 → 5秒後に再起動します🔄"
    sleep 5
    notify_discord "🦐 ナルエビ三世を再起動します🌅"
  fi
  claude --dangerously-skip-permissions --channels plugin:discord@claude-plugins-official -c
  echo "ナルエビ三世が終了しました。5秒後に再起動します..."
done

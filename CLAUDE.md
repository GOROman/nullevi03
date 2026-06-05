# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

「ナルエビちゃん三世」は、Claude Code を Discord Bot 経由で常時稼働させるための極小ラッパー。リポジトリ本体には Bot ロジックは存在せず、`claude` CLI を `claude-plugins-official` の `plugin:discord` チャンネルに繋いで起動・再起動するだけのシェルスクリプトで構成されている。

## 起動方法

```sh
DISCORD_BOT_TOKEN=... DISCORD_WEBHOOK_URL=... ./boot.sh
```

- `boot.sh` は `claude --dangerously-skip-permissions --channels plugin:discord@claude-plugins-official -c` を無限ループで実行し、終了したら 5 秒待って再起動する。
- 初回起動と再起動の各イベントを Discord Webhook にプッシュ通知する (`notify_discord` 関数。`{"content":"..."}` を JSON で POST)。
- `DISCORD_BOT_TOKEN` はプラグイン (MCP サーバ) が Discord に接続するために使用するため `export` している。`DISCORD_WEBHOOK_URL` は通知専用。
- `-c` フラグで前回セッションを継続するため、会話状態は Claude Code 側のセッション履歴に依存する。

## 必須の前提

- Claude Code が CLI として導入されていること (Max プラン等の課金が前提と README に記載)。
- `claude-plugins-official` 配下の Discord プラグインが設定済みであること (`/plugin install discord@claude-plugins-official`)。Bot 作成は Discord Developer Portal で行い、Message Content Intent を有効化する。MCP サーバは Bun 上で動くため Bun も必要。
- 環境変数 `DISCORD_BOT_TOKEN` (プラグイン接続用) と `DISCORD_WEBHOOK_URL` (通知用) を実際の値に置換する (boot.sh 内のデフォルト値はダミー)。
- 初回は `--channels` 付きで起動し、Bot に DM → 返ってくるペアリングコードで `/discord:access pair <code>` を実行して紐付ける。

## 編集時の注意

- スクリプトは POSIX sh で書かれている (`#!/bin/sh`)。bash 固有構文を持ち込まないこと。
- 認証情報は boot.sh にハードコードせず、必ず環境変数経由で渡す前提を崩さない。
- `--dangerously-skip-permissions` を外す変更は挙動を大きく変えるため、ユーザー確認を取ること。

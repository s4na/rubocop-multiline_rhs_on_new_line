# このプロジェクトについて

- RuboCop のカスタムルールを追加する Ruby gem
- gem 名: `rubocop-multiline_rhs_on_new_line`
- ライセンス: MIT
- OSS として公開する前提で、コード・コミット・PR を丁寧に管理する

# 開発環境

- Ruby バージョンは `.ruby-version` または `Gemfile` の指定に従う
- 依存関係は `bundle install` で準備する
- テストは RSpec: `bundle exec rspec`
- Lint は RuboCop 自身で: `bundle exec rubocop`

# コーディング規約

- RuboCop の既存 cop 実装を参考にしてスタイルを合わせる
- cop クラスは `RuboCop::Cop::` 名前空間に配置する
- 各 cop には必ず `MSG` 定数と `on_*` ハンドラを定義する
- テストは `RuboCop::RSpec::ExpectOffense` を使って期待する offense を明示する
- パブリック API（クラス・メソッド名）は変更しないこと。変更が必要なら CHANGELOG に記載して major/minor バージョンを上げる

# コミット

- コミットメッセージは **英語** で書く（OSS なので世界中の人が読める形式にする）
- タイトルは命令形・50文字以内: `Add cop for multiline RHS`, `Fix false positive in...`
- 本文には **Why** と **What** を書く（How はコードで自明なら省略可）
- 1コミット1つの論理的な変更にする（cop の追加・テストの追加・ドキュメント更新は別々でもよい）
- コミット後は必ず `git log --oneline -5` で意図通りか確認する
- コミットを勝手に削除・改変（rebase, reset, amend等）しないこと。明示的な指示がない限り禁止
- push は明示的に指示されたときのみ行う

## コミットタイプの例

- `Add`: 新しい cop・機能の追加
- `Fix`: バグ修正・false positive / false negative の修正
- `Update`: 既存動作の変更・設定の更新
- `Refactor`: 振る舞いを変えない内部整理
- `Test`: テストの追加・修正
- `Docs`: README・CHANGELOG などドキュメントのみの変更
- `Chore`: CI・Gemspec などメンテナンス作業

# PR

- タイトルは英語・命令形（コミットと同じルール）
- 本文に以下のセクションを書く:
  - **Summary**: 何をするPRか1〜3行で
  - **Motivation**: なぜこの変更が必要か
  - **Changes**: 主な変更点の箇条書き
  - **Testing**: テスト方法・追加したテストケースの説明
  - **Breaking Changes**: あれば明記（なければ省略可）
- PR には必ず対応するテストを含める
- CHANGELOG.md を更新してから PR を作成する

# リリース

- バージョンは `lib/rubocop/multiline_rhs_on_new_line/version.rb` で管理
- セマンティックバージョニング（SemVer）に従う
  - patch: バグ修正のみ
  - minor: 後方互換のある機能追加
  - major: 後方互換のない変更（cop の削除・挙動の大幅変更等）
- リリース前に CHANGELOG.md の `[Unreleased]` セクションをバージョン番号に変更する
- `git tag` でタグを打ち、`gem push` でリリースする（明示的な指示があるときのみ実行）

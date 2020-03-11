# ~~技術書典8~~ 技術書典 応援祭 Phoenix版サンプルコード

~~技術書典8~~ 技術書典 応援祭 で頒布した書籍「RailsエンジニアのためのElixir/Phoenix」のPhoenix版サンプルコードです。

## 必要なもの

- Erlang 22.2.6
- Elixir 1.10.1
- Node.js 12.15.0

## セットアップ

```
$ mix do deps.get, ecto.setup
$ npm install --prefix assets/
```

## 起動

```
$ mix phx.server
```

http://localhost:4000

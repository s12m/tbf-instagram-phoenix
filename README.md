# ~~技術書典8~~ 技術書典 応援祭 Phoenix版サンプルコード

~~技術書典8~~ 技術書典 応援祭 で頒布した書籍「RailsエンジニアのためのElixir/Phoenix」のPhoenix版サンプルコードです。

## 必要なもの

- Erlang 22.1.5
- Elixir 1.9.2
- Node.js 12.13.0

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

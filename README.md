# DartGPT

## Setup

- `dart pub get`
- `mkdir -p ~/.config/gpt`
- `cp env.json.template ~/.config/gpt/env.json` and update it with your [OpenAPI API key](https://platform.openai.com/account/api-keys).
- `dart run`

## Deploy

- `dart compile exe bin/dart_gpt.dart -o gpt`
- `mv gpt <DIRECTORY IN YOUR PATH>`

## Usage

```
$ cat "Hey there!"|gpt
```

or

```
$ gpt
Hey there!<Ctrl+D>
```

## Quote from ChatGPT

> Using ChatGPT in your terminal is an exciting and innovative way to have meaningful conversations and access valuable information. With this powerful AI tool at your fingertips, you can explore a wealth of knowledge, connect with people from all over the world, and stay connected 24/7. So why wait? Start using ChatGPT in your terminal today and open up a world of possibilities!

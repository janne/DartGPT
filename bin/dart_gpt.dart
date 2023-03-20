import 'dart:convert';
import 'dart:io';

import '../src/bot.dart';

Future<String> loadAPIKey() async {
  final home = Platform.environment['HOME'] ?? ".";
  final file = File('$home/.config/gpt/env.json');
  final content = await file.readAsString();
  final json = jsonDecode(content) as Map<String, dynamic>;
  return json['API_KEY'] as String;
}

Future<void> main(List<String> args) async {
  final bot = Bot(await loadAPIKey());
  await stdin.hasTerminal ? dialog(bot) : oneShot(bot);
}

Future<void> dialog(Bot bot) async {
  while (true) {
    stdout.write("> ");
    final input = stdin.readLineSync(encoding: utf8);
    if (input == null) break;
    await bot.sendMessage(input);
    print(lineBreak(bot.lastResponse()) + "\n");
  }
}

String lineBreak(String msg) {
  return msg
      .split("\n")
      .join("\n ")
      .split(" ")
      .fold(<String>[""], (lines, word) {
        if (lines.last.endsWith('\n')) return [...lines, word];
        final newLine = "${lines.last} $word";
        if (newLine.trim().length > 80) return [...lines, word];
        return [...lines.sublist(0, lines.length - 1), newLine];
      })
      .map((s) => s.trimRight())
      .join("\n");
}

Future<void> oneShot(Bot bot) async {
  final input = stdin.readLineSync(encoding: utf8);
  if (input == null) {
    print("No input, exiting.");
    exit(1);
  }

  await bot.sendMessage(input);
  print(bot.lastResponse());
}

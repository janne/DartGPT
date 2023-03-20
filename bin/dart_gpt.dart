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
  bot.deinit();
}

Future<void> dialog(Bot bot) async {
  while (true) {
    stdout.write("Human: ");
    final input = stdin.readLineSync(encoding: utf8);
    if (input == null) break;
    await bot.sendMessage(input);
    print(bot.lastResponse());
  }
}

Future<void> oneShot(Bot bot) async {
  final input = stdin.readLineSync(encoding: utf8);
  if (input == null) {
    print("No input, exiting.");
    bot.deinit();
    exit(1);
  }

  await bot.sendMessage(input);
  print(bot.lastResponse());
}

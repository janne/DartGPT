import 'dart:convert';
import 'dart:io';

import 'package:openai_client/openai_client.dart';
import 'package:openai_client/src/model/openai_chat/chat_message.dart';

Future<OpenAIConfiguration> loadConfigurationFromEnvFile() async {
  final home = Platform.environment['HOME'] ?? ".";
  final file = File('$home/.config/gpt/env.json');
  final content = await file.readAsString();
  final json = jsonDecode(content) as Map<String, dynamic>;

  return OpenAIConfiguration(apiKey: json['API_KEY'] as String);
}

Future<OpenAIClient> getClient() async {
  // Load app credentials from environment variables or file.
  final configuration = await loadConfigurationFromEnvFile();

  // Create a new client.
  return OpenAIClient(
    configuration: configuration,
    enableLogging: true,
  );
}

Future<String> sendMessage(OpenAIClient client, String prompt) async {
  // Create a chat.
  final chat = await client.chat.create(
    model: 'gpt-3.5-turbo',
    messages: [ChatMessage(role: 'user', content: prompt)],
  ).data;

  final message = chat.choices.first.message;
  return message.content.trim();
}

Future<void> main() async {
  final input = stdin.readLineSync(encoding: utf8);
  if (input == null) {
    print("No input, exiting.");
    exit(1);
  }

  final client = await getClient();
  final answer = await sendMessage(client, input);

  print(answer);

  client.close();
}

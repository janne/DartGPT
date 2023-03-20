import 'package:openai_client/openai_client.dart';
import 'package:openai_client/src/model/openai_chat/chat_message.dart';

class Bot {
  late OpenAIClient client;
  List<String> memory = [];

  Bot(String openai_api_key) {
    final config = OpenAIConfiguration(apiKey: openai_api_key);
    client = OpenAIClient(configuration: config);
  }

  Future<void> sendMessage(String input) async {
    memory.add("Human: $input");

    final message = ChatMessage(role: 'user', content: input);
    final chatRequest = client.chat.create(
      model: 'gpt-3.5-turbo',
      messages: [
        ChatMessage(role: 'user', content: input),
      ],
    );
    final chat = await chatRequest.data;
    final response = chat.choices.first.message.content.trim();

    memory.add("Bot: $response");
  }

  String lastResponse() => memory.last;

  deinit() {
    client.close();
  }
}

import 'package:openai_client/openai_client.dart';
import 'package:openai_client/src/model/openai_chat/chat_message.dart';

const MEMORY_LENGTH = 10;

class Bot {
  final String _apiKey;
  List<ChatMessage> _memory = [];

  Bot(this._apiKey);

  Future<void> sendMessage(String input) async {
    final config = OpenAIConfiguration(apiKey: _apiKey);
    final client = OpenAIClient(configuration: config);

    _memory.add(ChatMessage(role: "user", content: input));

    final count = MEMORY_LENGTH * 2 + 1;
    final messages = (_memory.length > count ? _memory.sublist(_memory.length - count) : _memory);

    final chatRequest = client.chat.create(model: 'gpt-3.5-turbo', messages: messages);
    final chat = await chatRequest.data;
    final response = chat.choices.first.message.content.trim();

    _memory.add(ChatMessage(role: "assistant", content: response));

    client.close();
  }

  String lastResponse() => _memory.last.content;

  int memoryDepth() => (_memory.length / 2).floor();
}

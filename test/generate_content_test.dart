import 'dart:convert';
import 'dart:io';

import 'package:generative_ai_dart/generative_ai_dart.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('Generate Content test', () async {
    final model = GenerativeModel(
        apiKey: String.fromEnvironment('GEMINI_API_KEY'),
        params: ModelParams(model: 'gemini-pro-vision'));

    final parts = [
      Part.text("Is it a cat?"),
      Part.blob(File('test_resources/cat.png').readAsBytesSync())
    ];

    final response = model.generateContentStream([Content.user(parts)]);

    print(jsonEncode(await response.toList()));
  });
}

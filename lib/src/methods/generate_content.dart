import 'dart:async';

import 'package:generative_ai_dart/generative_ai_dart.dart';
import 'package:generative_ai_dart/src/stream_reader.dart';

Future<GenerateContentResponse> generateContent(
    String apiKey, String model, GenerateContentRequest params) async {
  final url = RequestUrl(model, Task.generateContent, apiKey);

  final response =
      await url.fetchJson(params, GenerateContentResponse.fromJson);

  return response;
}

Stream<GenerateContentResponse> generateContentStream(
    String apiKey, String model, GenerateContentRequest params) async* {
  final url = RequestUrl(model, Task.streamGenerateContent, apiKey);

  final stream = await url.fetch(params);

  yield* processStream(stream);
}

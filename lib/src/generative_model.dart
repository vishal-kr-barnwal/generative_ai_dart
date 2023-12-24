import 'dart:async';
import 'dart:convert';

import 'package:generative_ai_dart/generative_ai_dart.dart';

final _responseLineRE = RegExp(r'^data: (.*)(?:\n\n|\r\r|\r\n\r\n)');

Stream<GenerateContentResponse> _processStream(Stream<String> stream) {
  final controller = StreamController<GenerateContentResponse>();
  var currentText = "";

  stream.listen(
    (value) {
      currentText += value;
      var match = _responseLineRE.firstMatch(currentText);

      while (match != null) {
        try {
          final response = GenerateContentResponse.fromJson(
              jsonDecode(match.group(1)!) as Map<String, dynamic>);

          controller.add(response);
        } catch (e) {
          controller.addError(GoogleGenerativeAIError(
            "Error parsing JSON response: \"${match.group(1)}\"",
          ));

          return;
        }

        currentText = currentText.substring(match.group(0)!.length);
        match = _responseLineRE.firstMatch(currentText);
      }
    },
    onDone: () {
      if (currentText.trim().isNotEmpty) {
        controller.addError(GoogleGenerativeAIError("Failed to parse stream"));
      }
      controller.close();
    },
    onError: (e) {
      controller.addError(e);
    },
  );

  return controller.stream;
}

class GenerativeModel {
  final String model;
  final String apiKey;
  final List<SafetySetting> safetySettings;
  final GenerationConfig generationConfig;

  GenerativeModel({required this.apiKey, required ModelParams params})
      : model = params.model,
        generationConfig = params.generationConfig,
        safetySettings = params.safetySettings;

  Stream<GenerateContentResponse> generateContentStream(
      List<Content> request) async* {
    final stream = await RequestType.streamGenerateContent.fetch(
        this,
        GenerateContentRequest(
            contents: request,
            generationConfig: generationConfig,
            safetySettings: safetySettings));

    yield* _processStream(stream);
  }

  ChatSession startChat([List<Content> history = const []]) =>
      ChatSession(model: this, history: history);

  Future<GenerateContentResponse> generateContent(List<Content> request) =>
      RequestType.generateContent.fetchJson(
          this,
          GenerateContentRequest(
              contents: request,
              generationConfig: generationConfig,
              safetySettings: safetySettings),
          GenerateContentResponse.fromJson);

  Future<EmbedContentResponse> embedContent(EmbedContentRequest params) =>
      RequestType.embedContent
          .fetchJson(this, params, EmbedContentResponse.fromJson);

  Future<BatchEmbedContentsResponse> batchEmbedContents(
          List<EmbedContentRequest> request) =>
      RequestType.batchEmbedContents.fetchJson(
          this,
          BatchEmbedContentsRequest(requests: request),
          BatchEmbedContentsResponse.fromJson);

  Future<CountTokensResponse> countTokens(List<Content> request) =>
      RequestType.countTokens.fetchJson(this,
          CountTokensRequest(contents: request), CountTokensResponse.fromJson);
}

import 'package:generative_ai_dart/generative_ai_dart.dart';
import 'package:generative_ai_dart/src/stream_reader.dart';

final class GenerativeModel {
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
    final url = RequestUrl(model, Task.streamGenerateContent, apiKey);

    final stream = await url.fetch(GenerateContentRequest(
        contents: request,
        generationConfig: generationConfig,
        safetySettings: safetySettings));

    yield* processStream(stream);
  }

  Future<GenerateContentResponse> generateContent(List<Content> request) {
    final url = RequestUrl(model, Task.generateContent, apiKey);

    return url.fetchJson(
        GenerateContentRequest(
            contents: request,
            generationConfig: generationConfig,
            safetySettings: safetySettings),
        GenerateContentResponse.fromJson);
  }

  Future<EmbedContentResponse> embedContent(EmbedContentRequest params) {
    final url = RequestUrl(model, Task.embedContent, apiKey);

    return url.fetchJson(params, EmbedContentResponse.fromJson);
  }

  Future<BatchEmbedContentsResponse> batchEmbedContents(
      List<EmbedContentRequest> request) {
    final url = RequestUrl(model, Task.embedContent, apiKey);

    return url.fetchJson(BatchEmbedContentsRequest(requests: request),
        BatchEmbedContentsResponse.fromJson);
  }

  Future<CountTokensResponse> countTokens(List<Content> request) {
    final url = RequestUrl(model, Task.countTokens, apiKey);

    return url.fetchJson(
        CountTokensRequest(contents: request), CountTokensResponse.fromJson);
  }
}

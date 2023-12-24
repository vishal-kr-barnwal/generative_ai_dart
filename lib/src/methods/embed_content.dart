import 'package:generative_ai_dart/generative_ai_dart.dart';

Future<EmbedContentResponse> embedContent(
    String apiKey, String model, EmbedContentRequest params) async {
  final url = RequestUrl(model, Task.embedContent, apiKey);

  return await url.fetchJson(params, EmbedContentResponse.fromJson);
}

Future<BatchEmbedContentsResponse> batchEmbedContents(
    String apiKey, String model, BatchEmbedContentsRequest params) async {
  final url = RequestUrl(model, Task.embedContent, apiKey);

  return await url.fetchJson(params, BatchEmbedContentsResponse.fromJson);
}

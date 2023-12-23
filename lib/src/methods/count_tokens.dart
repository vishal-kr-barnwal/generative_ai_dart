import 'package:generative_ai_dart/generative_ai_dart.dart';

Future<CountTokensResponse> countTokens(
    String apiKey, String model, CountTokensRequest params) async {
  final url = RequestUrl(model, Task.countTokens, apiKey, false);

  return await url.fetchJson(params, CountTokensResponse.fromJson);
}

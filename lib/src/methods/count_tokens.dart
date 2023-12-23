/*
export async function countTokens(
  apiKey: string,
  model: string,
  params: CountTokensRequest,
): Promise<CountTokensResponse> {
  const url = new RequestUrl(model, Task.COUNT_TOKENS, apiKey, false);
  const response = await makeRequest(url, JSON.stringify({ ...params, model }));
  return response.json();
}

 */

import 'dart:convert';
import 'dart:io';

import 'package:generative_ai_dart/generative_ai_dart.dart';
import 'package:generative_ai_dart/src/extensions/request_url_extension.dart';
import 'package:generative_ai_dart/src/types/request_url.dart';

Future<CountTokensResponse> countTokens(
    String apiKey, String model, CountTokensRequest params) async {
  final client = HttpClient();
  final url = RequestUrl(model, Task.countTokens, apiKey, false);

  final response = await url.fetch(jsonEncode(params.toJson()), client);

  final json = await response.transform(utf8.decoder).join();

  client.close();

  return CountTokensResponse.fromJson(jsonDecode(json) as Map<String, dynamic>);
}

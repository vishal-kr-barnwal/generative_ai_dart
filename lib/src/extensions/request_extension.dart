import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:generative_ai_dart/generative_ai_dart.dart';

import '../logger.dart';
import '../version.dart';

const _baseUrl = "https://generativelanguage.googleapis.com";

const _apiVersion = "v1";

final _clientName = 'genai-dart/$packageVersion';

extension Request on RequestType {
  Uri _toUri(final String model) {
    return Uri.parse('$_baseUrl/$_apiVersion/models/$model:$name')
        .replace(queryParameters: {if (isStream()) 'alt': 'sse'});
  }

  Future<T> fetchJson<T>(final GenerativeModel model, final Object body,
      final T Function(Map<String, dynamic> fromJson) fromJson) async {
    if (isStream()) {
      throw GoogleGenerativeAIError(
          "Use fetch instead of fetchJson for Streaming request");
    }

    final response = await fetch(model, body);
    final json = await response.join();

    return fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<Stream<String>> fetch<T>(
      final GenerativeModel model, final T body) async {
    try {
      final client = HttpClient();

      final url = _toUri(model.model);

      final response = await (await client.postUrl(url)
            ..headers.contentType = ContentType.json
            ..headers.add("x-goog-api-key", model.apiKey)
            ..headers.add("x-goog-api-client", _clientName)
            ..write(jsonEncode(body)))
          .close();

      if (response.ok) {
        final controller = StreamController<String>();
        final stream = response.transform(utf8.decoder);

        stream.listen((data) => controller.add(data), onDone: () {
          controller.close();
          client.close();
        }, onError: (err) {
          controller.addError(err);
          client.close();
        });

        return controller.stream;
      }

      var message = "";
      try {
        final error = (jsonDecode(await response.transform(utf8.decoder).join())
            as Map<String, dynamic>)["error"] as Map<String, dynamic>;
        message = error["message"];

        if (error["details"] != null) {
          message += " ${jsonEncode(error["details"])}";
        }
      } catch (e) {
        // Ignoring
      }

      throw Exception('[${response.statusCode}] $message');
    } catch (e, stackTrace) {
      log.severe(
          "Error fetching from ${toString()}: ${e.toString()}", e, stackTrace);
      throw GoogleGenerativeAIError(
          "Error fetching from ${toString()}: ${e.toString()}");
    }
  }
}

extension on HttpClientResponse {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:generative_ai_dart/generative_ai_dart.dart';
import 'package:generative_ai_dart/src/logger.dart';

extension MakeRequest on RequestUrl {
  Future<T> fetchJson<T>(
      Object body, T Function(Map<String, dynamic> fromJson) fromJson) async {
    if (task.isStream()) {
      throw GoogleGenerativeAIError(
          "Use fetch instead of fetchJson for Streaming request");
    }

    final response = await fetch(body);
    final json = await response.join();

    return fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<Stream<String>> fetch<T>(final T body) async {
    try {
      final client = HttpClient();

      final url = toUri();

      final response = await (await client.postUrl(url)
            ..headers.contentType = ContentType.json
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

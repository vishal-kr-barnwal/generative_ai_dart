import 'dart:convert';
import 'dart:io';

import 'package:generative_ai_dart/generative_ai_dart.dart';
import 'package:generative_ai_dart/src/logger.dart';
import 'package:generative_ai_dart/src/types/request_url.dart';

extension MakeRequest on RequestUrl {
  Future<HttpClientResponse> fetch(
      final String body, final HttpClient client) async {
    try {
      final response = await (await client.postUrl(toUri())
            ..headers.contentType = ContentType.json
            ..write(body))
          .close();

      if (response.ok) {
        return response;
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

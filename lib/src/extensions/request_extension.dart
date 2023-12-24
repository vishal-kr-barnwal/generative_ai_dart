import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:generative_ai_dart/generative_ai_dart.dart';

import '../logger.dart';
import '../version.dart';

const _baseUrl = "https://generativelanguage.googleapis.com";

const _apiVersion = "v1";

/// [_clientName] is a final variable containing the client's name
/// and the package version he is currently using.
///
/// You can refer this to fetch the name and the version of the package
/// the client is using.
final _clientName = 'genai-dart/$packageVersion';

/// Extension on [RequestType] to provide additional functionality.
extension Request on RequestType {
  /// Converts the provided [model] into a [Uri] with given parameters.
  ///
  /// Parameters:
  ///
  /// - model: Name of the machine learning model.
  ///
  /// Returns [Uri] created from the input model.
  Uri _toUri(final String model) {
    return Uri.parse('$_baseUrl/$_apiVersion/models/$model:$name')
        .replace(queryParameters: {if (isStream()) 'alt': 'sse'});
  }

  /// Fetches and decodes a JSON response.
  ///
  /// Parameters:
  ///
  /// - model: The [GenerativeModel] to fetch data from.
  /// - body: The body data to send with the request.
  /// - fromJson: Function that converts [Map] to a specified model.
  ///
  /// Returns deserialized response data.
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
    final client = HttpClient();

    try {
      final url = _toUri(model.model);

      final response = await (await client.postUrl(url)
            ..headers.contentType = ContentType.json
            ..headers.add("x-goog-api-key", model.apiKey)
            ..headers.add("x-goog-api-client", _clientName)
            ..write(jsonEncode(body)))
          .close();

      if (response.ok) {
        return _handleOKResponseAndCloseClient(response, client);
      }

      String message = await _getErrorMessage(response);

      client.close();

      throw GoogleGenerativeAIError(
          'API Call failed with Status :- [${response.statusCode}] $message');
    } catch (e, stackTrace) {
      client.close();

      log.severe(
          "Error fetching from ${toString()}: ${e.toString()}", e, stackTrace);
      throw GoogleGenerativeAIError(
          "Error fetching from ${toString()}: ${e.toString()}");
    }
  }

  Future<String> _getErrorMessage(HttpClientResponse response) async {
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
    return message;
  }

  Stream<String> _handleOKResponseAndCloseClient(
      HttpClientResponse response, HttpClient client) {
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
}

/// [HttpClientResponse] extension introduces additional capabilities.
///
/// This extension introduces a getter called 'ok' which checks if the HTTP response
/// status code is successful (in the 200-299 range).
///
/// For example, to check if a response was successful, you can:
///
/// ```Dart
/// if (response.ok) {
///   print('Request was successful');
/// }
/// ```
extension on HttpClientResponse {
  /// Checks if the [HttpClientResponse] has a status code in the 2xx range.
  ///
  /// Returns true if the HTTP status code of the [HttpClientResponse] indicates
  /// success (200-299).
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}

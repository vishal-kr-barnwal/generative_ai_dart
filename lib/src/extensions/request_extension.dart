import 'dart:async';
import 'dart:convert';

import 'package:generative_ai_dart/generative_ai_dart.dart';
import 'package:http/http.dart' as http;

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

  /// Fetches data from a given GenerativeModel.
  ///
  /// This function is asynchronous and returns a `Future` containing a
  /// continuous stream of `String` data.
  ///
  /// It takes in two parameters:
  /// - [model]: A [GenerativeModel] instance.
  /// - [body]: A generic data type [`T`](https://api.dart.dev/stable/2.9.2/dart-core/T-class.html).
  ///
  /// Initially, it establishes an HTTP client and constructs a URL using
  /// `model.model`. It then performs a post operation to that URL, setting
  /// several headers and writing the body in JSON format. If the response
  /// is OK, handles the responses and closes the client, otherwise,
  /// it gets the error message, closes the client and throws a [GoogleGenerativeAIError].
  ///
  /// During any part of this process, if an error occurs, it logs the error,
  /// closes the client, and throws a `GoogleGenerativeAIError` with a description
  /// of the error.
  ///
  /// Throws:
  /// - [GoogleGenerativeAIError]
  ///
  /// Example usage:
  /// ```dart
  /// await RequestType.generateContent.fetch(myModel, myBody);
  /// ```
  Future<Stream<String>> fetch<T>(
      final GenerativeModel model, final T body) async {
    final client = http.Client();

    try {
      final url = _toUri(model.model);

      final request = http.Request('POST', url)
        ..body = jsonEncode(body)
        ..headers.addAll({
          'content-type': 'application/json',
          'x-goog-api-key': model.apiKey,
          'x-goog-api-client': _clientName,
        });

      final response = await client.send(request);

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

  /// Future function [_getErrorMessage] gets error messages from
  /// [http.StreamedResponse] received as a response.
  ///
  /// Reference:
  /// * [http.StreamedResponse] used in function arguments.
  /// * [Future] represents a potential value, or error, that will be available
  /// at some time in the future.
  Future<String> _getErrorMessage(http.StreamedResponse response) async {
    var message = "";

    try {
      final error =
          (jsonDecode(await response.stream.transform(utf8.decoder).join())
              as Map<String, dynamic>)["error"] as Map<String, dynamic>;
      message = error["message"];

      if (error["details"] != null) {
        message += " ${jsonEncode(error["details"])}";
      }
    } catch (e) {
      // Ignoring exceptions
    }
    return message;
  }

  /// Handles a successful HTTP response by closing the client and returning the
  /// response data as a [Stream<String>].
  ///
  /// This function accepts [http.StreamedResponse] and [http.Client] as arguments.
  /// It transforms the response to UTF-8 format and listens to the stream. The
  /// response data is added to the [controller] which is an instance of
  /// [StreamController<String>]. When the stream is drained, the controller
  /// and the HTTP client are closed. If an error occurs during this process, the
  /// error is transferred to the controller and the client is closed.
  ///
  /// If there is no error, the controller's stream is returned. This stream
  /// contains the response data.
  ///
  /// References:
  /// * [http.StreamedResponse] is a future-based HTTP client.
  /// * [http.Client] a client that receives content, like HTTP requests.
  /// * [StreamController] controls a stream that sends events to its listeners.
  Stream<String> _handleOKResponseAndCloseClient(
      http.StreamedResponse response, http.Client client) {
    final controller = StreamController<String>();
    final stream = response.stream.transform(utf8.decoder);

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

/// [http.StreamedResponse] extension introduces additional capabilities.
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
extension on http.StreamedResponse {
  /// Checks if the [http.StreamedResponse] has a status code in the 2xx range.
  ///
  /// Returns true if the HTTP status code of the [http.StreamedResponse] indicates
  /// success (200-299).
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}

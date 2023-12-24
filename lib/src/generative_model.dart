import 'dart:async';
import 'dart:convert';

import 'package:generative_ai_dart/generative_ai_dart.dart';

/// Regular Expression for parsing response lines.
final _responseLineRE = RegExp(r'^data: (.*)(?:\n\n|\r\r|\r\n\r\n)');

/// Processes the provided [stream] of data and generates a Stream of
/// [GenerateContentResponse] instances.
///
/// This function begins by creating an empty StreamController. It then listens
/// for data in the provided [stream]. With each new string value that arrives,
/// it tries to find match using [_responseLineRE]. If match is found, data is
/// parsed and added into the controller as [GenerateContentResponse] instances.
///
/// If parsing throws an error, [GoogleGenerativeAIError] is added into the
/// controller with the problematic data.
///
/// After all the data from the stream has been processed and if [currentText] is not
/// empty, [GoogleGenerativeAIError] is added into the controller reporting failed
/// stream parsing.
///
/// The function ends by returning the stream of the controller.
///
/// Note about error handling: If any error occurs during the listening
/// of [stream], this error is added into the controller.
///
/// Throws: [GoogleGenerativeAIError] if it fails to parse the stream or if it
/// encounters an error while parsing the JSON response.
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

/// `GenerativeModel` class handles the structure and functionality of a generative
/// language model which includes [apiKey], [ModelParams], [GenerationConfig] and
/// [SafetySetting]. It contains several methods like [generateContentStream],
/// [startChat], [generateContent], [embedContent], [batchEmbedContents], and
/// [countTokens].
class GenerativeModel {
  /// Model identifier
  final String model;

  /// API key for model
  final String apiKey;

  /// Collection of safety settings to control the content generation
  final List<SafetySetting> safetySettings;

  /// Configuration settings for content generation
  final GenerationConfig generationConfig;

  GenerativeModel({required this.apiKey, required ModelParams params})
      : model = params.model,
        generationConfig = params.generationConfig,
        safetySettings = params.safetySettings;

  /// This function [generateContentStream] generate stream of content on
  /// specified parameters. This method implements [RequestType.streamGenerateContent].
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

  /// This function [startChat] starts a chat session. The function accepts list
  /// of previous chat [history] as optional parameter. Default is empty list.
  ChatSession startChat([List<Content> history = const []]) =>
      ChatSession(model: this, history: history);

  /// This function [generateContent] generates the content based on request and
  /// returns the Future of [GenerateContentResponse]. It utilizes
  /// the function [RequestType.generateContent].
  Future<GenerateContentResponse> generateContent(List<Content> request) =>
      RequestType.generateContent.fetchJson(
          this,
          GenerateContentRequest(
              contents: request,
              generationConfig: generationConfig,
              safetySettings: safetySettings),
          GenerateContentResponse.fromJson);

  /// This function [embedContent] embeds the content based on request parameters
  /// and returns the Future of [EmbedContentResponse]. It uses
  /// the function [RequestType.embedContent].
  Future<EmbedContentResponse> embedContent(EmbedContentRequest params) =>
      RequestType.embedContent
          .fetchJson(this, params, EmbedContentResponse.fromJson);

  /// This function [batchEmbedContents] embeds a batch of contents based on
  /// request parameters and returns the Future of [BatchEmbedContentsResponse].
  /// This method uses [RequestType.batchEmbedContents].
  Future<BatchEmbedContentsResponse> batchEmbedContents(
          List<EmbedContentRequest> request) =>
      RequestType.batchEmbedContents.fetchJson(
          this,
          BatchEmbedContentsRequest(requests: request),
          BatchEmbedContentsResponse.fromJson);

  /// [countTokens] method counts tokens of the supplied contents in the request and
  /// returns Future of [CountTokensResponse]. Here, the function
  /// [RequestType.countTokens] is used.
  Future<CountTokensResponse> countTokens(List<Content> request) =>
      RequestType.countTokens.fetchJson(this,
          CountTokensRequest(contents: request), CountTokensResponse.fromJson);
}

import 'dart:async';

import 'package:generative_ai_dart/generative_ai_dart.dart';

/// `ChatSession` manages interaction with a [GenerativeModel].
///
/// It sends messages to and receives messages from an AI model.
class ChatSession {
  /// An instance of [GenerativeModel] used for generating AI responses.
  final GenerativeModel _model;

  /// [_history] stores the conversation history between the user and the AI.
  final List<Content> _history;

  /// [_sendCompleter] used as a locking mechanism for asynchronous sending.
  var _sendCompleter = Completer()..complete();

  /// Constructs a [ChatSession] with a provided [GenerativeModel].
  ///
  /// [history] is the optional parameter for pre-existing conversation history.
  ChatSession(
      {required GenerativeModel model, List<Content> history = const []})
      : _model = model,
        _history = [...history];

  /// Fetch the chat history.
  ///
  /// Returns a [Future] that completes with the message history.
  Future<List<Content>> getHistory() =>
      _sendCompleter.future.then((_) => _history);

  /// *Important:* This method is crucial for preserving the send-receive order.
  ///
  /// It ensures that a send operation is only possible once the previous
  /// send operation has completed, thus avoiding overlaps.
  Future<void> _lockSend() async {
    await _sendCompleter.future;

    _sendCompleter = Completer();
  }

  /// Sends a message to the AI model and waits for the response.
  ///
  /// Returns a [Future] that completes with the AI-generated content.
  /// See also: [_lockSend]
  Future<GenerateContentResponse> sendMessage(List<Part> message) async {
    await _lockSend();
    final content = Content.user(message);
    final request = [..._history, content];

    try {
      final response = await _model.generateContent(request);

      _updateHistoryAndCompleteSend(content, [response]);

      return response;
    } catch (_, __) {
      _sendCompleter.complete();
      rethrow;
    }
  }

  /// Sends a message to the AI and gets the response in a [Stream].
  ///
  /// Yields [GenerateContentResponse] from the AI in a stream.
  ///
  /// See also: [_lockSend]
  Stream<GenerateContentResponse> sendMessageStream(List<Part> message) async* {
    await _lockSend();
    final content = Content.user(message);
    final request = [..._history, content];

    try {
      final response = _model.generateContentStream(request);

      unawaited(_updateHistoryFromStreamAndCompleteSend(content, response));

      yield* response;
    } catch (_, __) {
      _sendCompleter.complete();
      rethrow;
    }
  }

  /// Update the chat history based on responses from the AI [Stream].
  ///
  /// Asynchronously waits for the response [Stream] and updates the chat history.
  Future<void> _updateHistoryFromStreamAndCompleteSend(
      Content input, Stream<GenerateContentResponse> output) async {
    try {
      final response = await output.toList();

      _updateHistoryAndCompleteSend(input, response);
    } catch (_, __) {
      _sendCompleter.complete();
    }
  }

  /// Updates chat history and completes the [_sendCompleter].
  ///
  /// This function is called once the AI response is received.
  void _updateHistoryAndCompleteSend(
      Content input, List<GenerateContentResponse> output) {
    _history.add(input);

    final outputContent = output
        .map((e) => e.candidates ?? [])
        .expand((element) => element)
        .map((e) => e.content);

    _history.addAll(outputContent
        .map((e) => (e.role == null) ? Content.model(e.parts) : e));

    _sendCompleter.complete();
  }
}

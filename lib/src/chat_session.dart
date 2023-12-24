import 'dart:async';

import 'package:generative_ai_dart/generative_ai_dart.dart';

final class ChatSession {
  final GenerativeModel _model;
  final List<Content> _history;
  var _sendCompleter = Completer()..complete();

  ChatSession(
      {required GenerativeModel model, List<Content> history = const []})
      : _model = model,
        _history = [...history];

  Future<List<Content>> getHistory() =>
      _sendCompleter.future.then((value) => _history);

  Future<void> _lockSend() async {
    await _sendCompleter.future;

    _sendCompleter = Completer();
  }

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

  Future<void> _updateHistoryFromStreamAndCompleteSend(
      Content input, Stream<GenerateContentResponse> output) async {
    try {
      final response = await output.toList();

      _updateHistoryAndCompleteSend(input, response);
    } catch (_, __) {
      _sendCompleter.complete();
    }
  }

  void _updateHistoryAndCompleteSend(
      Content input, List<GenerateContentResponse> output) {
    _history.add(input);

    final outputContent = output
        .map((e) => e.candidates ?? [])
        .expand((element) => element)
        .map((e) => e.content);

    _history.addAll(outputContent.map((e) {
      if (e.role == null) {
        return Content.model(e.parts);
      }

      return e;
    }));

    _sendCompleter.complete();
  }
}

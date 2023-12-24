import 'package:generative_ai_dart/generative_ai_dart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGenerativeModel extends Mock implements GenerativeModel {}

void main() {
  group('ChatSession', () {
    late MockGenerativeModel model;
    late ChatSession chat;

    final chatHistory = [
      Content.user([Part.text("Hi")]),
      Content.model([Part.text("Hello")])
    ];

    setUp(() {
      model = MockGenerativeModel();
      chat = ChatSession(model: model, history: chatHistory);
    });

    test('getHistory() returns correct history', () async {
      expect(chat.getHistory(), completes);

      final history = await chat.getHistory();

      expect(history.length, 2);
      expect(history, chatHistory);
    });

    test(
        'sendMessage() should pass history to the model &, update history accordingly.',
        () async {
      final prompt = [Part.text('Request '), Part.text('from user')];
      final response = GenerateContentResponse(candidates: [
        GenerateContentCandidate(
            index: 0,
            content: Content.model([Part.text('Response from model.')]))
      ], promptFeedback: null);

      when(() => model.generateContent(any())).thenAnswer((final invocation) {
        final input = invocation.positionalArguments[0] as List<Content>;

        expect(input.length, 3);
        expect(input[0], chatHistory[0]);
        expect(input[1], chatHistory[1]);
        expect(input[2].role, 'user');
        expect(input[2].parts, prompt);

        return Future.value(response);
      });

      expect(await chat.sendMessage(prompt), response);

      verify(() => model.generateContent(any())).called(1);

      final history = await chat.getHistory();

      expect(history.length, 4);
      expect(history[0], chatHistory[0]);
      expect(history[1], chatHistory[1]);
      expect(history[2].role, "user");
      expect(history[2].parts, prompt);
      expect(history[3], response.candidates![0].content);
    });

    test(
        'sendMessageStream() should pass history to the model &, update history accordingly.',
        () async {
      final prompt = [Part.text('Request '), Part.text('from user')];
      final response = [
        GenerateContentResponse(candidates: [
          GenerateContentCandidate(
              index: 0, content: Content.model([Part.text('Response ')]))
        ], promptFeedback: null),
        GenerateContentResponse(candidates: [
          GenerateContentCandidate(
              index: 0, content: Content.model([Part.text('from ')]))
        ], promptFeedback: null),
        GenerateContentResponse(candidates: [
          GenerateContentCandidate(
              index: 0, content: Content.model([Part.text('model.')]))
        ], promptFeedback: null)
      ];

      when(() => model.generateContentStream(any()))
          .thenAnswer((final invocation) {
        final input = invocation.positionalArguments[0] as List<Content>;

        expect(input.length, 3);
        expect(input[0], chatHistory[0]);
        expect(input[1], chatHistory[1]);
        expect(input[2].role, 'user');
        expect(input[2].parts, prompt);

        return Stream.fromIterable(response);
      });

      expect(await chat.sendMessageStream(prompt).toList(), response);

      verify(() => model.generateContentStream(any())).called(1);

      final history = await chat.getHistory();

      expect(history.length, 6);
      expect(history[0], chatHistory[0]);
      expect(history[1], chatHistory[1]);
      expect(history[2].role, "user");
      expect(history[2].parts, prompt);
      expect(history[3], response[0].candidates![0].content);
      expect(history[4], response[1].candidates![0].content);
      expect(history[5], response[2].candidates![0].content);
    });
  });
}

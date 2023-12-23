import 'package:generative_ai_dart/src/content.dart';
import 'package:test/test.dart';

void main() {
  group('Part', () {
    test('fromJson factory constructor with text', () {
      final part = Part.fromJson({'text': 'a'});
      expect(part, isA<TextPart>());
      expect(part.text, 'a');
    });

    test('fromJson factory constructor with inlineData', () {
      final part = Part.fromJson({
        'inlineData': {'mimeType': 'application/text', 'data': 'hi'}
      });
      expect(part, isA<InlineDataPart>());

      expect(part.inlineData, isNotNull);
      expect(part.inlineData!.mimeType, 'application/text');
      expect(part.inlineData!.data, 'hi');
    });

    test('fromJson factory constructor with text and inlineData', () {
      final part = Part.fromJson({
        'text': 'a',
        'inlineData': {'key': 'value'}
      });
      expect(part, isA<TextPart>());
      expect(part.text, 'a');
    });

    test('fromJson factory constructor with null text and inlineData', () {
      expect(
        () => Part.fromJson({'text': null, 'inlineData': null}),
        throwsA(isA<AssertionError>()),
      );
    });

    test('toJson method', () {
      final textPart = TextPart('a');
      expect(
        textPart.toJson(),
        {'text': 'a', 'inlineData': null},
      );

      // Assuming GenerativeContentBlob.toJson() returns {'key': 'value'}
      final inlineDataPart = InlineDataPart(GenerativeContentBlob.fromJson(
          {'mimeType': 'application/text', 'data': 'hi'}));
      expect(
        inlineDataPart.toJson(),
        {
          'text': null,
          'inlineData': {'mimeType': 'application/text', 'data': 'hi'}
        },
      );
    });
  });
}

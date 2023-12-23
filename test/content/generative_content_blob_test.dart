// Include the test package
import 'package:generative_ai_dart/src/types/content.dart';
import 'package:test/test.dart';

void main() {
  group('GenerativeContentBlob', () {
    test('GenerativeContentBlob is correctly constructed from values', () {
      var blob = GenerativeContentBlob(mimeType: 'text/plain', data: 'hello');
      expect(blob.mimeType, 'text/plain');
      expect(blob.data, 'hello');
    });

    test('GenerativeContentBlob is correctly constructed from JSON', () {
      var blobJson = {'mimeType': 'image/png', 'data': 'testimage'};
      var blob = GenerativeContentBlob.fromJson(blobJson);
      expect(blob.mimeType, 'image/png');
      expect(blob.data, 'testimage');
    });

    test('GenerativeContentBlob is correctly serialized into JSON', () {
      var blob = GenerativeContentBlob(mimeType: 'text/plain', data: 'hello');
      var blobJson = blob.toJson();
      expect(blobJson['mimeType'], 'text/plain');
      expect(blobJson['data'], 'hello');
    });
  });
}

import 'package:generative_ai_dart/generative_ai_dart.dart';
import 'package:test/test.dart';

void main() {
  test('Test Content.fromJson and Content.toJson', () {
    final testJson = {
      "parts": [
        {"text": "hi"},
        {"text": "hello"}
      ],
      "role": "user"
    };

    final contentFromJson = Content.fromJson(testJson);
    expect(contentFromJson.role, testJson["role"]);

    final contentToJson = contentFromJson.toJson();
    expect(contentToJson["role"], testJson["role"]);

    expect((contentToJson["parts"] as List<dynamic>).length, 2);

    final firstPart = contentToJson["parts"][0];
    expect(firstPart, {"text": "hi", 'inlineData': null});

    final secondPart = contentToJson["parts"][1];
    expect(secondPart, {"text": "hello", 'inlineData': null});
  });

  test('Test InputContent.fromJson and InputContent.toJson', () {
    final inputContentJson = {"parts": "string part", "role": "user"};

    final inputContentFromJson = InputContent.fromJson(inputContentJson);
    expect(inputContentFromJson.role, inputContentJson["role"]);

    final inputContentToJson = inputContentFromJson.toJson();
    expect(inputContentToJson["role"], inputContentJson["role"]);
    expect(inputContentToJson["parts"], "string part");
  });

  test('Test InputContent from list', () {
    final inputContentListJson = {
      "parts": [
        "part1",
        {"text": "text content 1"}
      ],
      "role": "admin"
    };

    final inputContentFromJson = InputContent.fromJson(inputContentListJson);
    expect(inputContentFromJson.role, inputContentListJson["role"]);

    final inputContentToJson = inputContentFromJson.toJson();

    expect(inputContentToJson["role"], inputContentListJson["role"]);
    expect((inputContentToJson["parts"] as List<dynamic>).length, 2);
    expect(inputContentToJson["parts"][0], "part1");
    expect(inputContentToJson["parts"][1],
        {"text": "text content 1", "inlineData": null});
  });

  test('Test must fail when invalid type passed in parts list', () {
    final inputContentListJson = {
      "parts": [
        "part1",
        {"type": "invalid", "content": "text content 1"}
      ],
      "role": "admin"
    };
    try {
      InputContent.fromJson(inputContentListJson);
    } catch (e) {
      expect(e, isA<AssertionError>());
    }
  });
}

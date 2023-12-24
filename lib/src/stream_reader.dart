import 'dart:async';
import 'dart:convert';

import 'package:generative_ai_dart/generative_ai_dart.dart';

final responseLineRE = RegExp(r'^data: (.*)(?:\n\n|\r\r|\r\n\r\n)');

Stream<GenerateContentResponse> processStream(Stream<String> stream) {
  final controller = StreamController<GenerateContentResponse>();
  var currentText = "";

  stream.listen(
    (value) {
      currentText += value;
      var match = responseLineRE.firstMatch(currentText);

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
        match = responseLineRE.firstMatch(currentText);
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

import 'package:generative_ai_dart/generative_ai_dart.dart';

import '../logger.dart';

/// [_badFinishReasons] holds list of bad finish reasons.
final _badFinishReasons = [FinishReason.recitation, FinishReason.safety];

/// This is an extension method for [GenerateContentCandidate] class.
extension on GenerateContentCandidate {
  /// Returns true if the current object has a bad finish reason.
  bool hadBadFinishReason() {
    return (finishReason != null && _badFinishReasons.contains(finishReason));
  }
}

/// This is an extension method for [GenerateContentResponse] class.
extension GenerateContentResponseExtension on GenerateContentResponse {
  /// Returns text after several checks and validations.
  String text() {
    if (candidates != null && candidates!.isNotEmpty) {
      if (candidates![0].hadBadFinishReason()) {
        throw GoogleGenerativeAIResponseError(formatBlockErrorMessage(), this);
      }

      if (candidates!.length > 1) {
        log.warning(
            "This response had ${candidates!.length} candidates. Returning text from the first candidate only."
            " Access response.candidates directly to use the other candidates.");
      }

      return _getText();
    } else if (promptFeedback != null) {
      throw GoogleGenerativeAIResponseError(
          "Text not available. ${formatBlockErrorMessage()}", this);
    }

    return "";
  }

  /// Formats the error message when the content is blocked.
  String formatBlockErrorMessage() {
    var message = "";
    if ((candidates?.isEmpty ?? true) && promptFeedback != null) {
      message +=
          "Response was blocked due to ${promptFeedback!.blockReason?.name} : ${promptFeedback!.blockReasonMessage}";
    } else if (candidates?.isNotEmpty ?? false) {
      final firstCandidate = candidates![0];
      message +=
          "Candidate was blocked due to ${firstCandidate.finishReason?.name}";
      if (firstCandidate.hadBadFinishReason()) {
        message += ": ${firstCandidate.finishMessage}";
      }
    }

    return message;
  }

  /// Returns the text of the first valid candidate's content part
  String _getText() {
    if (candidates != null && candidates!.isNotEmpty) {
      var firstCandidate = candidates!.first;

      if (firstCandidate.content.parts.isNotEmpty) {
        return firstCandidate.content.parts.first.text ?? "";
      }
    }

    return "";
  }
}

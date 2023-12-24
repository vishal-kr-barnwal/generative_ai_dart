import 'package:generative_ai_dart/generative_ai_dart.dart';

import '../logger.dart';

final _badFinishReasons = [FinishReason.recitation, FinishReason.safety];

extension on GenerateContentCandidate {
  bool hadBadFinishReason() {
    return (finishReason != null && _badFinishReasons.contains(finishReason));
  }
}

extension on List<GenerateContentResponse> {
  GenerateContentResponse aggregate() {
    final promptFeedback = lastOrNull?.promptFeedback;

    final candidates = map((e) => e.candidates)
        .whereType<List<GenerateContentCandidate>>()
        .expand((element) => element);

    if (candidates.isEmpty) {
      return GenerateContentResponse(
          candidates: null, promptFeedback: promptFeedback);
    }

    final indexedCandidates =
        Map.fromEntries(candidates.map((e) => MapEntry(e.index, e)));

    final keys = indexedCandidates.keys.toList()..sort();

    return GenerateContentResponse(
        candidates: keys.isEmpty
            ? null
            : keys.map((e) => indexedCandidates[e]!).toList(),
        promptFeedback: promptFeedback);
  }
}

extension GenerateContentResponseAggregator on Stream<GenerateContentResponse> {
  Future<GenerateContentResponse> toResponse() async {
    final responses = await toList();

    return responses.aggregate();
  }
}

extension GenerateContentResponseExtension on GenerateContentResponse {
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

  String formatBlockErrorMessage() {
    var message = "";
    if ((candidates?.isEmpty ?? true) && promptFeedback != null) {
      message +=
          "Response was blocked due to ${promptFeedback!.blockReason.name} : ${promptFeedback!.blockReasonMessage}";
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

  String _getText() =>
      candidates?.firstOrNull?.content.parts.firstOrNull?.text ?? "";
}

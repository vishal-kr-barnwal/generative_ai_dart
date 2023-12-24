import 'package:generative_ai_dart/generative_ai_dart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'responses.g.dart';

@JsonSerializable()
class ContentEmbedding {
  final List<int> values;

  ContentEmbedding(this.values);

  factory ContentEmbedding.fromJson(Map<String, dynamic> json) =>
      _$ContentEmbeddingFromJson(json);

  Map<String, dynamic> toJson() => _$ContentEmbeddingToJson(this);
}

@JsonSerializable()
class BatchEmbedContentsResponse {
  final List<ContentEmbedding> embeddings;

  BatchEmbedContentsResponse(this.embeddings);

  factory BatchEmbedContentsResponse.fromJson(Map<String, dynamic> json) =>
      _$BatchEmbedContentsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BatchEmbedContentsResponseToJson(this);
}

@JsonSerializable()
class EmbedContentResponse {
  final ContentEmbedding embedding;

  EmbedContentResponse(this.embedding);

  factory EmbedContentResponse.fromJson(Map<String, dynamic> json) =>
      _$EmbedContentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmbedContentResponseToJson(this);
}

@JsonSerializable()
class CountTokensResponse {
  final int totalTokens;

  CountTokensResponse(this.totalTokens);

  factory CountTokensResponse.fromJson(Map<String, dynamic> json) =>
      _$CountTokensResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CountTokensResponseToJson(this);
}

@JsonSerializable()
class SafetyRating {
  final HarmCategory category;
  final HarmProbability probability;

  SafetyRating({required this.category, required this.probability});

  factory SafetyRating.fromJson(Map<String, dynamic> json) =>
      _$SafetyRatingFromJson(json);

  Map<String, dynamic> toJson() => _$SafetyRatingToJson(this);
}

@JsonSerializable()
class CitationSource {
  final int? startIndex;
  final int? endIndex;
  final String? uri;
  final String? license;

  CitationSource({this.startIndex, this.endIndex, this.license, this.uri});

  factory CitationSource.fromJson(Map<String, dynamic> json) =>
      _$CitationSourceFromJson(json);

  Map<String, dynamic> toJson() => _$CitationSourceToJson(this);
}

@JsonSerializable()
class CitationMetadata {
  final List<CitationSource> citationSources;

  CitationMetadata(this.citationSources);

  factory CitationMetadata.fromJson(Map<String, dynamic> json) =>
      _$CitationMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$CitationMetadataToJson(this);
}

@JsonSerializable()
class GenerateContentCandidate {
  final int index;
  final Content content;
  final FinishReason? finishReason;
  final String? finishMessage;
  final List<SafetyRating>? safetyRatings;
  final CitationMetadata? citationMetadata;

  GenerateContentCandidate(
      {required this.index,
      required this.content,
      this.finishReason,
      this.finishMessage,
      this.safetyRatings,
      this.citationMetadata});

  factory GenerateContentCandidate.fromJson(Map<String, dynamic> json) =>
      _$GenerateContentCandidateFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateContentCandidateToJson(this);
}

@JsonSerializable()
class PromptFeedback {
  final BlockReason? blockReason;
  final List<SafetyRating> safetyRatings;
  final String? blockReasonMessage;

  PromptFeedback(
      {this.safetyRatings = const [],
      this.blockReason,
      this.blockReasonMessage});

  factory PromptFeedback.fromJson(Map<String, dynamic> json) =>
      _$PromptFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$PromptFeedbackToJson(this);
}

@JsonSerializable()
class GenerateContentResponse {
  final List<GenerateContentCandidate>? candidates;
  final PromptFeedback? promptFeedback;

  GenerateContentResponse(
      {required this.candidates, required this.promptFeedback});

  String text() {
    return "";
  }

  factory GenerateContentResponse.fromJson(Map<String, dynamic> json) =>
      _$GenerateContentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateContentResponseToJson(this);
}

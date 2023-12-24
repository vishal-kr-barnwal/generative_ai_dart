import 'package:generative_ai_dart/generative_ai_dart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'responses.g.dart';

/// [ContentEmbedding] class represents the content embedding.
/// It consists of a list of integer values.
@JsonSerializable()
class ContentEmbedding {
  final List<int> values;

  ContentEmbedding(this.values);

  /// Factory constructor for creating a new [ContentEmbedding] instance
  factory ContentEmbedding.fromJson(Map<String, dynamic> json) =>
      _$ContentEmbeddingFromJson(json);

  /// Declares support for serialization to JSON
  Map<String, dynamic> toJson() => _$ContentEmbeddingToJson(this);
}

/// [BatchEmbedContentsResponse] class represents the response
/// for a batch of embeddings. It consists of a list of [ContentEmbedding].
@JsonSerializable()
class BatchEmbedContentsResponse {
  final List<ContentEmbedding> embeddings;

  BatchEmbedContentsResponse(this.embeddings);

  /// Factory constructor for creating a new [BatchEmbedContentsResponse] instance
  factory BatchEmbedContentsResponse.fromJson(Map<String, dynamic> json) =>
      _$BatchEmbedContentsResponseFromJson(json);

  /// Declares support for serialization to JSON
  Map<String, dynamic> toJson() => _$BatchEmbedContentsResponseToJson(this);
}

/// [EmbedContentResponse] class represents the response
/// for an embedded content. It consists of a [ContentEmbedding].
@JsonSerializable()
class EmbedContentResponse {
  final ContentEmbedding embedding;

  EmbedContentResponse(this.embedding);

  /// Factory constructor for creating a new [EmbedContentResponse] instance
  factory EmbedContentResponse.fromJson(Map<String, dynamic> json) =>
      _$EmbedContentResponseFromJson(json);

  /// Declares support for serialization to JSON
  Map<String, dynamic> toJson() => _$EmbedContentResponseToJson(this);
}

/// [CountTokensResponse] class represents the response
/// for counting tokens which consists of total number of tokens.
@JsonSerializable()
class CountTokensResponse {
  final int totalTokens;

  CountTokensResponse(this.totalTokens);

  /// Factory constructor for creating a new [CountTokensResponse] instance
  factory CountTokensResponse.fromJson(Map<String, dynamic> json) =>
      _$CountTokensResponseFromJson(json);

  /// Declares support for serialization to JSON
  Map<String, dynamic> toJson() => _$CountTokensResponseToJson(this);
}

/// [SafetyRating] class represents a safety rating which contains
/// category and probability of harm.
@JsonSerializable()
class SafetyRating {
  final HarmCategory category;
  final HarmProbability probability;

  SafetyRating({required this.category, required this.probability});

  /// Factory constructor for creating a new [SafetyRating] instance
  factory SafetyRating.fromJson(Map<String, dynamic> json) =>
      _$SafetyRatingFromJson(json);

  /// Declares support for serialization to JSON
  Map<String, dynamic> toJson() => _$SafetyRatingToJson(this);
}

/// [CitationSource] class represents a citation source with start index, end
/// index, URI and license.
@JsonSerializable()
class CitationSource {
  final int? startIndex;
  final int? endIndex;
  final String? uri;
  final String? license;

  /// Creates a new instance of a [CitationSource].
  ///
  /// Takes [startIndex], [endIndex], [uri] and [license] as parameters.
  CitationSource({this.startIndex, this.endIndex, this.license, this.uri});

  /// Factory constructor for creating a new [CitationSource] instance from JSON.
  factory CitationSource.fromJson(Map<String, dynamic> json) =>
      _$CitationSourceFromJson(json);

  /// A method to convert the [CitationSource] instance to JSON.
  Map<String, dynamic> toJson() => _$CitationSourceToJson(this);
}

/// [CitationMetadata] class represents a metadata that contains a list of
/// [CitationSource]s.
@JsonSerializable()
class CitationMetadata {
  final List<CitationSource> citationSources;

  /// Takes a list of [CitationSource]s as a parameter to create an instance
  /// of [CitationMetadata].
  CitationMetadata(this.citationSources);

  /// Factory constructor for creating a new [CitationMetadata] instance from JSON.
  factory CitationMetadata.fromJson(Map<String, dynamic> json) =>
      _$CitationMetadataFromJson(json);

  /// A method to convert the [CitationMetadata] instance to JSON.
  Map<String, dynamic> toJson() => _$CitationMetadataToJson(this);
}

/// `GenerateContentCandidate` is a Class, with JSON serializable
/// representation, that holds the data for generating content candidates.
/// It's properties include [index], [content], optional [finishReason],
/// [finishMessage], [safetyRatings], and [citationMetadata].
@JsonSerializable()
class GenerateContentCandidate {
  /// The [index] is a unique identifier for each generate content candidate.
  final int index;

  /// [content] is the actual data of the content.
  /// See [Content] for more details.
  final Content content;

  /// [finishReason] indicates why the content generation was finished.
  /// See [FinishReason] for possible reasons. It can be null.
  final FinishReason? finishReason;

  /// [finishMessage] is the final message when the content
  /// generation is finished. It can be null.
  final String? finishMessage;

  /// [safetyRatings] is a list of safety ratings for
  /// the generated content. Each item is an instance of [SafetyRating].
  /// It can be null.
  final List<SafetyRating>? safetyRatings;

  /// [citationMetadata] contains the citation information of the content.
  /// See [CitationMetadata] for more details. It can be null.
  final CitationMetadata? citationMetadata;

  /// The constructor for the `GenerateContentCandidate` class.
  /// It requires [index] and [content] as required parameters
  /// whereas, [finishReason], [finishMessage], [safetyRatings],
  /// and [citationMetadata] are optional.
  GenerateContentCandidate(
      {required this.index,
      required this.content,
      this.finishReason,
      this.finishMessage,
      this.safetyRatings,
      this.citationMetadata});

  /// Factory constructor to create `GenerateContentCandidate` from JSON.
  factory GenerateContentCandidate.fromJson(Map<String, dynamic> json) =>
      _$GenerateContentCandidateFromJson(json);

  /// Converts `GenerateContentCandidate` object to JSON.
  Map<String, dynamic> toJson() => _$GenerateContentCandidateToJson(this);
}

/// `PromptFeedback` is a class that represents a feedback for user's prompt.
///
/// It mainly includes:
///  - A [BlockReason] to identify the reason for blocking a prompt.
///  - A List<[SafetyRating]> which holds all the safety rating aspects of the prompt.
///  - A `String` block reason message that tells about the reason behind blockage of prompt.
///
///  It has a JSON-encodable structure, with `fromJson` and `toJson` methods
///  facilitating the serialization and deserialization operations respectively.
@JsonSerializable()
class PromptFeedback {
  /// Represents the [BlockReason] object to block the prompt.
  ///
  /// It is optional and can be `null`.
  final BlockReason? blockReason;

  /// A list of [SafetyRating] objects.
  ///
  /// They represent the safety ratings of the prompt.
  /// Default is an empty list.
  final List<SafetyRating> safetyRatings;

  /// The message string for the block reason.
  ///
  /// It is optional and can be `null`.
  final String? blockReasonMessage;

  /// Default constructor for `PromptFeedback`.
  PromptFeedback(
      {this.safetyRatings = const [],
      this.blockReason,
      this.blockReasonMessage});

  /// A factory constructor that forms a `PromptFeedback` object from a JSON map.
  ///
  /// [json] is a map of `String` keys to `dynamic` values.
  factory PromptFeedback.fromJson(Map<String, dynamic> json) =>
      _$PromptFeedbackFromJson(json);

  /// A method that converts a `PromptFeedback` object to a JSON Map.
  ///
  /// Returns a map of strings to dynamic.
  Map<String, dynamic> toJson() => _$PromptFeedbackToJson(this);
}

/// [GenerateContentResponse] is a class which collects the response of a content
/// generation operation. This includes the generated content candidates as well as
/// any feedback provided for the prompts.
///
/// It provides factory constructor for building the instance from JSON and method
/// to convert it back to JSON.
@JsonSerializable()
class GenerateContentResponse {
  /// The list of content candidates that was generated for the prompt.
  final List<GenerateContentCandidate>? candidates;

  /// The prompt feedback, if any, that was provided for the content generation.
  final PromptFeedback? promptFeedback;

  /// Creates an instance of [GenerateContentResponse]. Both parameters are
  /// required fields in this class.
  GenerateContentResponse(
      {required this.candidates, required this.promptFeedback});

  /// Creates a new instance of the [GenerateContentResponse] from a map structure.
  /// It's a [factory] constructor, which can return objects from cache.
  factory GenerateContentResponse.fromJson(Map<String, dynamic> json) =>
      _$GenerateContentResponseFromJson(json);

  /// Converts the [GenerateContentResponse] instance to a [Map] for JSON serialization.
  Map<String, dynamic> toJson() => _$GenerateContentResponseToJson(this);
}

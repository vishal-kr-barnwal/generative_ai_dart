import 'package:generative_ai_dart/generative_ai_dart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'requests.g.dart';

/// Represents the safety settings for content generation.
/// Contains a [HarmCategory] and [HarmBlockThreshold].
@JsonSerializable()
class SafetySetting {
  final HarmCategory category;
  final HarmBlockThreshold threshold;

  /// Creates a new instance of [SafetySetting].
  SafetySetting({required this.category, required this.threshold});

  /// Creates a new instance of [SafetySetting] from a JSON map.
  factory SafetySetting.fromJson(Map<String, dynamic> json) =>
      _$SafetySettingFromJson(json);

  /// Converts the [SafetySetting] instance to a JSON map.
  Map<String, dynamic> toJson() => _$SafetySettingToJson(this);
}

/// Represents a configuration for content generation.
/// It contains parameters like the temperature, the count of candidates
/// and more.
@JsonSerializable()
class GenerationConfig {
  final int? candidateCount;
  final List<String>? stopSequences;
  final int? maxOutputTokens;
  final num? temperature;
  final num? topP;
  final int? topK;

  /// Creates a new instance of [GenerationConfig].
  const GenerationConfig(
      {this.candidateCount,
      this.stopSequences,
      this.maxOutputTokens,
      this.temperature,
      this.topP,
      this.topK});

  /// Creates a new instance of [GenerationConfig] from a JSON map.
  factory GenerationConfig.fromJson(Map<String, dynamic> json) =>
      _$GenerationConfigFromJson(json);

  /// Converts the [GenerationConfig] instance to a JSON map.
  Map<String, dynamic> toJson() => _$GenerationConfigToJson(this);
}

abstract class _BaseParams {
  final List<SafetySetting> safetySettings;
  final GenerationConfig generationConfig;

  /// Creates a new instance of [_BaseParams].
  _BaseParams(
      {this.safetySettings = const [],
      this.generationConfig = const GenerationConfig()});

  Map<String, dynamic> toJson();
}

/// Represents the parameters associated with a specific model.
@JsonSerializable()
class ModelParams extends _BaseParams {
  final String model;

  /// Creates a new instance of [ModelParams].
  ModelParams(
      {required this.model, super.generationConfig, super.safetySettings});

  /// Creates a new instance of [ModelParams] from a JSON map.
  factory ModelParams.fromJson(Map<String, dynamic> json) =>
      _$ModelParamsFromJson(json);

  /// Converts the [ModelParams] instance to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$ModelParamsToJson(this);
}

/// Represents a request for content generation.
@JsonSerializable()
class GenerateContentRequest extends _BaseParams {
  final List<Content> contents;

  /// Creates a new instance of [GenerateContentRequest].
  GenerateContentRequest(
      {required this.contents, super.generationConfig, super.safetySettings});

  /// Creates a new instance of [GenerateContentRequest] from a JSON map.
  factory GenerateContentRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateContentRequestFromJson(json);

  /// Converts the [GenerateContentRequest] instance to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$GenerateContentRequestToJson(this);
}

/// Represents a request for counting tokens in contents.
@JsonSerializable()
class CountTokensRequest {
  final List<Content> contents;

  /// Creates a new instance of [CountTokensRequest].
  CountTokensRequest({required this.contents});

  /// Creates a new instance of [CountTokensRequest] from a JSON map.
  factory CountTokensRequest.fromJson(Map<String, dynamic> json) =>
      _$CountTokensRequestFromJson(json);

  /// Converts the [CountTokensRequest] instance to a JSON map.
  Map<String, dynamic> toJson() => _$CountTokensRequestToJson(this);
}

/// Represents a request for embedding content.
@JsonSerializable()
class EmbedContentRequest {
  final Content content;
  final TaskType taskType;
  final String title;

  /// Creates a new instance of [EmbedContentRequest].
  EmbedContentRequest(
      {required this.content, required this.taskType, required this.title});

  /// Creates a new instance of [EmbedContentRequest] from a JSON map.
  factory EmbedContentRequest.fromJson(Map<String, dynamic> json) =>
      _$EmbedContentRequestFromJson(json);

  /// Converts the [EmbedContentRequest] instance to a JSON map.
  Map<String, dynamic> toJson() => _$EmbedContentRequestToJson(this);
}

/// Represents a batch request for embedding contents.
@JsonSerializable()
class BatchEmbedContentsRequest {
  final List<EmbedContentRequest> requests;

  /// Creates a new instance of [BatchEmbedContentsRequest].
  BatchEmbedContentsRequest({required this.requests});

  /// Creates a new instance of [BatchEmbedContentsRequest] from a JSON map.
  factory BatchEmbedContentsRequest.fromJson(Map<String, dynamic> json) =>
      _$BatchEmbedContentsRequestFromJson(json);

  /// Converts the [BatchEmbedContentsRequest] instance to a JSON map.
  Map<String, dynamic> toJson() => _$BatchEmbedContentsRequestToJson(this);
}

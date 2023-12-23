import 'package:generative_ai_dart/generative_ai_dart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'requests.g.dart';

@JsonSerializable()
final class SafetySetting {
  final HarmCategory category;
  final HarmBlockThreshold threshold;

  SafetySetting({required this.category, required this.threshold});

  factory SafetySetting.fromJson(Map<String, dynamic> json) =>
      _$SafetySettingFromJson(json);

  Map<String, dynamic> toJson() => _$SafetySettingToJson(this);
}

@JsonSerializable()
final class GenerationConfig {
  final int? candidateCount;
  final List<String>? stopSequences;
  final int? maxOutputTokens;
  final num? temperature;
  final num? topP;
  final int? topK;

  GenerationConfig(
      {this.candidateCount,
      this.stopSequences,
      this.maxOutputTokens,
      this.temperature,
      this.topP,
      this.topK});

  factory GenerationConfig.fromJson(Map<String, dynamic> json) =>
      _$GenerationConfigFromJson(json);

  Map<String, dynamic> toJson() => _$GenerationConfigToJson(this);
}

@JsonSerializable()
base class BaseParams {
  final List<SafetySetting> safetySettings;
  final GenerationConfig generationConfig;

  BaseParams({required this.safetySettings, required this.generationConfig});

  factory BaseParams.fromJson(Map<String, dynamic> json) =>
      _$BaseParamsFromJson(json);

  Map<String, dynamic> toJson() => _$BaseParamsToJson(this);
}

@JsonSerializable()
final class ModelParams extends BaseParams {
  final String model;

  ModelParams(
      {required this.model,
      required super.generationConfig,
      required super.safetySettings});

  factory ModelParams.fromJson(Map<String, dynamic> json) =>
      _$ModelParamsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ModelParamsToJson(this);
}

@JsonSerializable()
final class GenerateContentRequest extends BaseParams {
  final List<Content> contents;

  GenerateContentRequest(
      {required this.contents,
      required super.generationConfig,
      required super.safetySettings});

  factory GenerateContentRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateContentRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GenerateContentRequestToJson(this);
}

@JsonSerializable()
final class StartChatParams extends BaseParams {
  final List<InputContent> history;

  StartChatParams(
      {required this.history,
      required super.generationConfig,
      required super.safetySettings});

  factory StartChatParams.fromJson(Map<String, dynamic> json) =>
      _$StartChatParamsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StartChatParamsToJson(this);
}

@JsonSerializable()
final class CountTokensRequest {
  final List<Content> contents;

  CountTokensRequest({required this.contents});

  factory CountTokensRequest.fromJson(Map<String, dynamic> json) =>
      _$CountTokensRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CountTokensRequestToJson(this);
}

@JsonSerializable()
final class EmbedContentRequest {
  final Content content;
  final TaskType taskType;
  final String title;

  EmbedContentRequest(
      {required this.content, required this.taskType, required this.title});

  factory EmbedContentRequest.fromJson(Map<String, dynamic> json) =>
      _$EmbedContentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EmbedContentRequestToJson(this);
}

@JsonSerializable()
final class BatchEmbedContentsRequest {
  final List<EmbedContentRequest> requests;

  BatchEmbedContentsRequest({required this.requests});

  factory BatchEmbedContentsRequest.fromJson(Map<String, dynamic> json) =>
      _$BatchEmbedContentsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BatchEmbedContentsRequestToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SafetySetting _$SafetySettingFromJson(Map<String, dynamic> json) =>
    SafetySetting(
      category: $enumDecode(_$HarmCategoryEnumMap, json['category']),
      threshold: $enumDecode(_$HarmBlockThresholdEnumMap, json['threshold']),
    );

Map<String, dynamic> _$SafetySettingToJson(SafetySetting instance) =>
    <String, dynamic>{
      'category': _$HarmCategoryEnumMap[instance.category]!,
      'threshold': _$HarmBlockThresholdEnumMap[instance.threshold]!,
    };

const _$HarmCategoryEnumMap = {
  HarmCategory.unspecified: 'HARM_CATEGORY_UNSPECIFIED',
  HarmCategory.hateSpeech: 'HARM_CATEGORY_HATE_SPEECH',
  HarmCategory.sexuallyExplicit: 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
  HarmCategory.harassment: 'HARM_CATEGORY_HARASSMENT',
  HarmCategory.dangerousContent: 'HARM_CATEGORY_DANGEROUS_CONTENT',
};

const _$HarmBlockThresholdEnumMap = {
  HarmBlockThreshold.unspecified: 'HARM_BLOCK_THRESHOLD_UNSPECIFIED',
  HarmBlockThreshold.blockLowAndAbove: 'BLOCK_LOW_AND_ABOVE',
  HarmBlockThreshold.blockMediumAndAbove: 'BLOCK_MEDIUM_AND_ABOVE',
  HarmBlockThreshold.blockOnlyHigh: 'BLOCK_ONLY_HIGH',
  HarmBlockThreshold.blockNone: 'BLOCK_NONE',
};

GenerationConfig _$GenerationConfigFromJson(Map<String, dynamic> json) =>
    GenerationConfig(
      candidateCount: json['candidateCount'] as int?,
      stopSequences: (json['stopSequences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      maxOutputTokens: json['maxOutputTokens'] as int?,
      temperature: json['temperature'] as num?,
      topP: json['topP'] as num?,
      topK: json['topK'] as int?,
    );

Map<String, dynamic> _$GenerationConfigToJson(GenerationConfig instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('candidateCount', instance.candidateCount);
  writeNotNull('stopSequences', instance.stopSequences);
  writeNotNull('maxOutputTokens', instance.maxOutputTokens);
  writeNotNull('temperature', instance.temperature);
  writeNotNull('topP', instance.topP);
  writeNotNull('topK', instance.topK);
  return val;
}

BaseParams _$BaseParamsFromJson(Map<String, dynamic> json) => BaseParams(
      safetySettings: (json['safetySettings'] as List<dynamic>?)
              ?.map((e) => SafetySetting.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      generationConfig: json['generationConfig'] == null
          ? const GenerationConfig()
          : GenerationConfig.fromJson(
              json['generationConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BaseParamsToJson(BaseParams instance) =>
    <String, dynamic>{
      'safetySettings': instance.safetySettings,
      'generationConfig': instance.generationConfig,
    };

ModelParams _$ModelParamsFromJson(Map<String, dynamic> json) => ModelParams(
      model: json['model'] as String,
      generationConfig: json['generationConfig'] == null
          ? const GenerationConfig()
          : GenerationConfig.fromJson(
              json['generationConfig'] as Map<String, dynamic>),
      safetySettings: (json['safetySettings'] as List<dynamic>?)
              ?.map((e) => SafetySetting.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ModelParamsToJson(ModelParams instance) =>
    <String, dynamic>{
      'safetySettings': instance.safetySettings,
      'generationConfig': instance.generationConfig,
      'model': instance.model,
    };

GenerateContentRequest _$GenerateContentRequestFromJson(
        Map<String, dynamic> json) =>
    GenerateContentRequest(
      contents: (json['contents'] as List<dynamic>)
          .map((e) => Content.fromJson(e as Map<String, dynamic>))
          .toList(),
      generationConfig: json['generationConfig'] == null
          ? const GenerationConfig()
          : GenerationConfig.fromJson(
              json['generationConfig'] as Map<String, dynamic>),
      safetySettings: (json['safetySettings'] as List<dynamic>?)
              ?.map((e) => SafetySetting.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GenerateContentRequestToJson(
        GenerateContentRequest instance) =>
    <String, dynamic>{
      'safetySettings': instance.safetySettings,
      'generationConfig': instance.generationConfig,
      'contents': instance.contents,
    };

StartChatParams _$StartChatParamsFromJson(Map<String, dynamic> json) =>
    StartChatParams(
      history: (json['history'] as List<dynamic>)
          .map((e) => InputContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      generationConfig: json['generationConfig'] == null
          ? const GenerationConfig()
          : GenerationConfig.fromJson(
              json['generationConfig'] as Map<String, dynamic>),
      safetySettings: (json['safetySettings'] as List<dynamic>?)
              ?.map((e) => SafetySetting.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$StartChatParamsToJson(StartChatParams instance) =>
    <String, dynamic>{
      'safetySettings': instance.safetySettings,
      'generationConfig': instance.generationConfig,
      'history': instance.history,
    };

CountTokensRequest _$CountTokensRequestFromJson(Map<String, dynamic> json) =>
    CountTokensRequest(
      contents: (json['contents'] as List<dynamic>)
          .map((e) => Content.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CountTokensRequestToJson(CountTokensRequest instance) =>
    <String, dynamic>{
      'contents': instance.contents,
    };

EmbedContentRequest _$EmbedContentRequestFromJson(Map<String, dynamic> json) =>
    EmbedContentRequest(
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
      taskType: $enumDecode(_$TaskTypeEnumMap, json['taskType']),
      title: json['title'] as String,
    );

Map<String, dynamic> _$EmbedContentRequestToJson(
        EmbedContentRequest instance) =>
    <String, dynamic>{
      'content': instance.content,
      'taskType': _$TaskTypeEnumMap[instance.taskType]!,
      'title': instance.title,
    };

const _$TaskTypeEnumMap = {
  TaskType.unspecified: 'TASK_TYPE_UNSPECIFIED',
  TaskType.retrievalQuery: 'RETRIEVAL_QUERY',
  TaskType.retrievalDocument: 'RETRIEVAL_DOCUMENT',
  TaskType.semanticSimilarity: 'SEMANTIC_SIMILARITY',
  TaskType.classification: 'CLASSIFICATION',
  TaskType.clustering: 'CLUSTERING',
};

BatchEmbedContentsRequest _$BatchEmbedContentsRequestFromJson(
        Map<String, dynamic> json) =>
    BatchEmbedContentsRequest(
      requests: (json['requests'] as List<dynamic>)
          .map((e) => EmbedContentRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BatchEmbedContentsRequestToJson(
        BatchEmbedContentsRequest instance) =>
    <String, dynamic>{
      'requests': instance.requests,
    };

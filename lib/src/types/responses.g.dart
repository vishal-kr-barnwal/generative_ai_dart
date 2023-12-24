// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentEmbedding _$ContentEmbeddingFromJson(Map<String, dynamic> json) =>
    ContentEmbedding(
      (json['values'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$ContentEmbeddingToJson(ContentEmbedding instance) =>
    <String, dynamic>{
      'values': instance.values,
    };

BatchEmbedContentsResponse _$BatchEmbedContentsResponseFromJson(
        Map<String, dynamic> json) =>
    BatchEmbedContentsResponse(
      (json['embeddings'] as List<dynamic>)
          .map((e) => ContentEmbedding.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BatchEmbedContentsResponseToJson(
        BatchEmbedContentsResponse instance) =>
    <String, dynamic>{
      'embeddings': instance.embeddings,
    };

EmbedContentResponse _$EmbedContentResponseFromJson(
        Map<String, dynamic> json) =>
    EmbedContentResponse(
      ContentEmbedding.fromJson(json['embedding'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EmbedContentResponseToJson(
        EmbedContentResponse instance) =>
    <String, dynamic>{
      'embedding': instance.embedding,
    };

CountTokensResponse _$CountTokensResponseFromJson(Map<String, dynamic> json) =>
    CountTokensResponse(
      json['totalTokens'] as int,
    );

Map<String, dynamic> _$CountTokensResponseToJson(
        CountTokensResponse instance) =>
    <String, dynamic>{
      'totalTokens': instance.totalTokens,
    };

SafetyRating _$SafetyRatingFromJson(Map<String, dynamic> json) => SafetyRating(
      category: $enumDecode(_$HarmCategoryEnumMap, json['category']),
      probability: $enumDecode(_$HarmProbabilityEnumMap, json['probability']),
    );

Map<String, dynamic> _$SafetyRatingToJson(SafetyRating instance) =>
    <String, dynamic>{
      'category': _$HarmCategoryEnumMap[instance.category]!,
      'probability': _$HarmProbabilityEnumMap[instance.probability]!,
    };

const _$HarmCategoryEnumMap = {
  HarmCategory.unspecified: 'HARM_CATEGORY_UNSPECIFIED',
  HarmCategory.hateSpeech: 'HARM_CATEGORY_HATE_SPEECH',
  HarmCategory.sexuallyExplicit: 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
  HarmCategory.harassment: 'HARM_CATEGORY_HARASSMENT',
  HarmCategory.dangerousContent: 'HARM_CATEGORY_DANGEROUS_CONTENT',
};

const _$HarmProbabilityEnumMap = {
  HarmProbability.unspecified: 'HARM_PROBABILITY_UNSPECIFIED',
  HarmProbability.negligible: 'NEGLIGIBLE',
  HarmProbability.low: 'LOW',
  HarmProbability.medium: 'MEDIUM',
  HarmProbability.high: 'HIGH',
};

CitationSource _$CitationSourceFromJson(Map<String, dynamic> json) =>
    CitationSource(
      startIndex: json['startIndex'] as int?,
      endIndex: json['endIndex'] as int?,
      license: json['license'] as String?,
      uri: json['uri'] as String?,
    );

Map<String, dynamic> _$CitationSourceToJson(CitationSource instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('startIndex', instance.startIndex);
  writeNotNull('endIndex', instance.endIndex);
  writeNotNull('uri', instance.uri);
  writeNotNull('license', instance.license);
  return val;
}

CitationMetadata _$CitationMetadataFromJson(Map<String, dynamic> json) =>
    CitationMetadata(
      (json['citationSources'] as List<dynamic>)
          .map((e) => CitationSource.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CitationMetadataToJson(CitationMetadata instance) =>
    <String, dynamic>{
      'citationSources': instance.citationSources,
    };

GenerateContentCandidate _$GenerateContentCandidateFromJson(
        Map<String, dynamic> json) =>
    GenerateContentCandidate(
      index: json['index'] as int,
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
      finishReason:
          $enumDecodeNullable(_$FinishReasonEnumMap, json['finishReason']),
      finishMessage: json['finishMessage'] as String?,
      safetyRatings: (json['safetyRatings'] as List<dynamic>?)
          ?.map((e) => SafetyRating.fromJson(e as Map<String, dynamic>))
          .toList(),
      citationMetadata: json['citationMetadata'] == null
          ? null
          : CitationMetadata.fromJson(
              json['citationMetadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GenerateContentCandidateToJson(
    GenerateContentCandidate instance) {
  final val = <String, dynamic>{
    'index': instance.index,
    'content': instance.content,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('finishReason', _$FinishReasonEnumMap[instance.finishReason]);
  writeNotNull('finishMessage', instance.finishMessage);
  writeNotNull('safetyRatings', instance.safetyRatings);
  writeNotNull('citationMetadata', instance.citationMetadata);
  return val;
}

const _$FinishReasonEnumMap = {
  FinishReason.unspecified: 'FINISH_REASON_UNSPECIFIED',
  FinishReason.stop: 'STOP',
  FinishReason.maxTokens: 'MAX_TOKENS',
  FinishReason.safety: 'SAFETY',
  FinishReason.recitation: 'RECITATION',
  FinishReason.other: 'OTHER',
};

PromptFeedback _$PromptFeedbackFromJson(Map<String, dynamic> json) =>
    PromptFeedback(
      safetyRatings: (json['safetyRatings'] as List<dynamic>?)
              ?.map((e) => SafetyRating.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      blockReason:
          $enumDecodeNullable(_$BlockReasonEnumMap, json['blockReason']),
      blockReasonMessage: json['blockReasonMessage'] as String?,
    );

Map<String, dynamic> _$PromptFeedbackToJson(PromptFeedback instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('blockReason', _$BlockReasonEnumMap[instance.blockReason]);
  val['safetyRatings'] = instance.safetyRatings;
  writeNotNull('blockReasonMessage', instance.blockReasonMessage);
  return val;
}

const _$BlockReasonEnumMap = {
  BlockReason.unspecified: 'BLOCKED_REASON_UNSPECIFIED',
  BlockReason.safety: 'SAFETY',
  BlockReason.other: 'OTHER',
};

GenerateContentResponse _$GenerateContentResponseFromJson(
        Map<String, dynamic> json) =>
    GenerateContentResponse(
      candidates: (json['candidates'] as List<dynamic>?)
          ?.map((e) =>
              GenerateContentCandidate.fromJson(e as Map<String, dynamic>))
          .toList(),
      promptFeedback: json['promptFeedback'] == null
          ? null
          : PromptFeedback.fromJson(
              json['promptFeedback'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GenerateContentResponseToJson(
    GenerateContentResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('candidates', instance.candidates);
  writeNotNull('promptFeedback', instance.promptFeedback);
  return val;
}

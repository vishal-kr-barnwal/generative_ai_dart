import 'package:json_annotation/json_annotation.dart';

/// Enum representing different categories of harm in the system responsible for
/// managing harmful prompts or candidates. Each value stands for a particular
/// type of harmful content that may lead to the blocking of a prompt or
/// candidate.
enum HarmCategory {
  @JsonValue("HARM_CATEGORY_UNSPECIFIED")

  /// Unspecified type of harm.
  unspecified,
  @JsonValue("HARM_CATEGORY_HATE_SPEECH")

  /// Harm category involving hate speech.
  hateSpeech,
  @JsonValue("HARM_CATEGORY_SEXUALLY_EXPLICIT")

  /// Harm category of sexually explicit content.
  sexuallyExplicit,
  @JsonValue("HARM_CATEGORY_HARASSMENT")

  /// Harm category involving harassment.
  harassment,
  @JsonValue("HARM_CATEGORY_DANGEROUS_CONTENT")

  /// Harm category of dangerous content.
  dangerousContent,
}

/// Enum representing a threshold level at which a prompt or candidate might be
/// blocked.
enum HarmBlockThreshold {
  @JsonValue("HARM_BLOCK_THRESHOLD_UNSPECIFIED")

  /// Threshold is unspecified.
  unspecified,
  @JsonValue("BLOCK_LOW_AND_ABOVE")

  /// NEGLIGIBLE content will be allowed.
  blockLowAndAbove,
  @JsonValue("BLOCK_MEDIUM_AND_ABOVE")

  /// NEGLIGIBLE and LOW content will be allowed.
  blockMediumAndAbove,
  @JsonValue("BLOCK_ONLY_HIGH")

  /// NEGLIGIBLE, LOW, and MEDIUM content will be allowed.
  blockOnlyHigh,
  @JsonValue("BLOCK_NONE")

  /// All content will be allowed.
  blockNone,
}

/// Enum representing the probability of a prompt or candidate matching a
/// harm category.
enum HarmProbability {
  @JsonValue("HARM_PROBABILITY_UNSPECIFIED")

  /// Probability is unspecified.
  unspecified,
  @JsonValue("NEGLIGIBLE")

  /// Negligible chance of content being unsafe.
  negligible,
  @JsonValue("LOW")

  /// Low chance of content being unsafe.
  low,
  @JsonValue("MEDIUM")

  /// Medium chance of content being unsafe.
  medium,
  @JsonValue("HIGH")

  /// High chance of content being unsafe.
  high,
}

/// Enum representing the reason a prompt was blocked.
enum BlockReason {
  @JsonValue("BLOCKED_REASON_UNSPECIFIED")

  /// Blocked reason not specified.
  unspecified,
  @JsonValue("SAFETY")

  /// Blocked due to safety settings.
  safety,
  @JsonValue("OTHER")

  /// Blocked for an uncategorized reason.
  other,
}

/// Enum representing the reason a candidate execution finished.
enum FinishReason {
  @JsonValue("FINISH_REASON_UNSPECIFIED")

  /// Default value. This value is unused.
  unspecified,
  @JsonValue("STOP")

  /// Natural stop point of the model or provided stop sequence.
  stop,
  @JsonValue("MAX_TOKENS")

  /// Maximum number of tokens as per the request was reached.
  maxTokens,
  @JsonValue("SAFETY")

  /// Candidate was flagged for safety reasons.
  safety,
  @JsonValue("RECITATION")

  /// Candidate was flagged for recitation reasons.
  recitation,
  @JsonValue("OTHER")

  /// Finish reason unknown.
  other,
}

/// An Enum in Dart representing the various types of tasks included in
/// embedding the content. The Enum [TaskType] has six different types of
/// tasks:
enum TaskType {
  @JsonValue("TASK_TYPE_UNSPECIFIED")

  /// Task type is not specified.
  unspecified,
  @JsonValue("RETRIEVAL_QUERY")

  /// Task involves retrieval based on query.
  retrievalQuery,
  @JsonValue("RETRIEVAL_DOCUMENT")

  /// Task involves retrieval of documents.
  retrievalDocument,
  @JsonValue("SEMANTIC_SIMILARITY")

  /// Task involves finding semantic similarities.
  semanticSimilarity,
  @JsonValue("CLASSIFICATION")

  /// Task involves classification.
  classification,
  @JsonValue("CLUSTERING")

  /// Task involves clustering.
  clustering,
}

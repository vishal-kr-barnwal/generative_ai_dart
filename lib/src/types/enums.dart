import 'package:json_annotation/json_annotation.dart';

/// This is an enum representing various types of requests. It includes methods
/// to generate content, stream content, count tokens, embed content, and batch
/// embed contents.
///
/// There is also a method to check if the request type is a stream generation
/// request.
enum RequestType {
  /// Reflects a request type that involves generating content.
  generateContent,

  /// Reflects a request type that involves generating and streaming content.
  streamGenerateContent,

  /// Reflects a request type that involves counting tokens.
  countTokens,

  /// Reflects a request type that involves embedding content.
  embedContent,

  /// Reflects a request type that involves batching and embedding content.
  batchEmbedContents;

  /// Method that checks whether request type is [streamGenerateContent].
  ///
  /// Returns `true` if the request type is [streamGenerateContent], else
  /// `false`.
  ///
  /// Example usage:
  /// ```
  /// bool isStreaming = RequestType.streamGenerateContent.isStream();
  /// ```
  bool isStream() => this == RequestType.streamGenerateContent;
}

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

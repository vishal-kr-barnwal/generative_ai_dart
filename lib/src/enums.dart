/// Enum representing different categories of harm in the system responsible for
/// managing harmful prompts or candidates. Each value stands for a particular
/// type of harmful content that may lead to the blocking of a prompt or
/// candidate.
enum HarmCategory {
  /// Unspecified type of harm.
  unspecified,

  /// Harm category involving hate speech.
  hateSpeech,

  /// Harm category of sexually explicit content.
  sexuallyExplicit,

  /// Harm category involving harassment.
  harassment,

  /// Harm category of dangerous content.
  dangerousContent,
}

/// Enum representing a threshold level at which a prompt or candidate might be
/// blocked.
enum HarmBlockThreshold {
  /// Threshold is unspecified.
  unspecified,

  /// NEGLIGIBLE content will be allowed.
  blockLowAndAbove,

  /// NEGLIGIBLE and LOW content will be allowed.
  blockMediumAndAbove,

  /// NEGLIGIBLE, LOW, and MEDIUM content will be allowed.
  blockOnlyHigh,

  /// All content will be allowed.
  blockNone,
}

/// Enum representing the probability of a prompt or candidate matching a
/// harm category.
enum HarmProbability {
  /// Probability is unspecified.
  harmProbabilityUnspecified,

  /// Negligible chance of content being unsafe.
  negligible,

  /// Low chance of content being unsafe.
  low,

  /// Medium chance of content being unsafe.
  medium,

  /// High chance of content being unsafe.
  high,
}

/// Enum representing the reason a prompt was blocked.
enum BlockReason {
  /// Blocked reason not specified.
  unspecified,

  /// Blocked due to safety settings.
  safety,

  /// Blocked for an uncategorized reason.
  other,
}

/// Enum representing the reason a candidate execution finished.
enum FinishReason {
  /// Default value. This value is unused.
  unspecified,

  /// Natural stop point of the model or provided stop sequence.
  stop,

  /// Maximum number of tokens as per the request was reached.
  maxTokens,

  /// Candidate was flagged for safety reasons.
  safety,

  /// Candidate was flagged for recitation reasons.
  recitation,

  /// Finish reason unknown.
  other,
}

/// An Enum in Dart representing the various types of tasks included in
/// embedding the content. The Enum [TaskType] has six different types of
/// tasks:
enum TaskType {
  /// Task type is not specified.
  unspecified,

  /// Task involves retrieval based on query.
  retrievalQuery,

  /// Task involves retrieval of documents.
  retrievalDocument,

  /// Task involves finding semantic similarities.
  semanticSimilarity,

  /// Task involves classification.
  classification,

  /// Task involves clustering.
  clustering,
}

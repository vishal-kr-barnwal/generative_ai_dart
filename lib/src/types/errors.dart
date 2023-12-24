/// Represents a class for Google Generative AI related errors.
///
/// Implements the [Exception] class. This class acts as a custom exception
/// handler that provides customized error messages for Google Generative AI
/// related errors.
class GoogleGenerativeAIError implements Exception {
  /// Holds the error message.
  String message;

  /// Initializes a new instance of the [GoogleGenerativeAIError] class.
  ///
  /// The [message] parameter determines the custom error message to use.
  GoogleGenerativeAIError(this.message);

  /// Overrides the [toString] method in the [Exception] class.
  ///
  /// This method returns a custom error message when an exception is thrown.
  @override
  String toString() {
    return '[GoogleGenerativeAI Error]: $message';
  }
}

/// Represents a class for Google Generative AI response related errors.
///
/// Extends the [GoogleGenerativeAIError] class. This class is specifically
/// meant to handle exceptions obtained from a Google Generative AI response.
class GoogleGenerativeAIResponseError<T> extends GoogleGenerativeAIError {
  /// Holds the response type.
  T response;

  /// Initializes a new instance of the [GoogleGenerativeAIResponseError] class.
  ///
  /// The [message] parameter is an error message. The [response] parameter is the
  /// response type related to the error.
  GoogleGenerativeAIResponseError(String message, this.response)
      : super(message);
}

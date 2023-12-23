class GoogleGenerativeAIError implements Exception {
  String message;

  GoogleGenerativeAIError(this.message);

  @override
  String toString() {
    return '[GoogleGenerativeAI Error]: $message';
  }
}

class GoogleGenerativeAIResponseError<T> extends GoogleGenerativeAIError {
  T response;

  GoogleGenerativeAIResponseError(String message, this.response)
      : super(message);
}

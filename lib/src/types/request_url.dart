const _baseUrl = "https://generativelanguage.googleapis.com";

const _apiVersion = "v1";

enum Task {
  generateContent,
  streamGenerateContent,
  countTokens,
  embedContent,
  batchEmbedContents;

  bool isStream() => this == Task.streamGenerateContent;
}

final class RequestUrl {
  final String model;
  final Task task;
  final String apiKey;

  RequestUrl(this.model, this.task, this.apiKey);

  @override
  String toString() {
    String url = '$_baseUrl/$_apiVersion/models/$model:$task';
    if (task.isStream()) {
      url += "?alt=sse";
    }
    return url;
  }

  Uri toUri() {
    final url = Uri.parse(toString());

    return url
        .replace(queryParameters: {...url.queryParameters, 'key': apiKey});
  }
}

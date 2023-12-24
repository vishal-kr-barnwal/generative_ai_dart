# Generative AI Dart

The `generative_ai_dart` is a powerful Dart library that interfaces with Google's GenAI models.
It supports diverse types of inputs and can generate robust chat sessions, making it a comprehensive tool for
leveraging AI in your Dart applications.

**This have been inspired from [Google Generative AI JS SDK](https://github.com/google/generative-ai-js)**

## Key Features

- **Google GenAI Models Interoperability:** The library provides seamless interaction with Google's GenAI models like
  Gemini, Gemini Vision, Palm, etc.
- **Diverse Input Support:** It can handle different types of inputs such as Blob and String, providing flexibility
  according to your needs.
- **Chat Session Generation:** It has the capability to generate and manage chat sessions.
- **Stream or Single Content Output:** You can choose to generate a stream of content or a single instance of
  content depending on your requirements.

## Installation

Run the following command in your shell :-

```shell
dart pub add generative-ai-dart
```

And, then you can start a chat session using :-

```dart
void main() {
  final genAI = GenerativeModel();
  genAI.startChat();
}
```

Refer to the complete documentation for more detailed usage instructions.

## Documentation

Complete documentation is available [here](https://pub.dev/documentation/generative_ai_dart/latest/).

## License

`generative_ai_dart` is available under the [MIT License](LICENSE).

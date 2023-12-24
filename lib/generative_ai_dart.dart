/// The `generative_ai_dart` library.
///
/// This library is a powerful tool for interacting with a wide array of
/// Google's GenAI models. It features broad input support, including Blob and
/// String data types, which enables it to generate robust chat sessions.
/// With this package, the output can be either a stream of content or a
/// singular content entity.
///
/// ## Key Features
/// - **Google GenAI Models Interoperability:** Seamless interaction with Google's GenAI models.
/// - **Diverse Input Support:** Supports different types of inputs such as Blob, String, etc.
/// - **Chat Session Generation:** Capable of spawning and managing chat sessions.
/// - **Stream or Single Content Output:** Allows generation of a stream of content or singular instances of content.
///
/// ## Usage
/// To interact with the Google GenAI models, import the library and create a model object:
///
/// ```dart
/// import 'package:generative_ai_dart/generative_ai_dart.dart';
///
/// void main() {
///   final genAI = GenerativeModel();
///   genAI.startChat();
/// }
/// ```
///
/// For more information on how to use this library, refer to the complete documentation.
library generative_ai_dart;

export 'src/generative_ai_dart_base.dart';

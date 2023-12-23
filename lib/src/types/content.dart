/// A [GenerativeContentBlob] object represents a content blob with
/// a specific MIME type and data.
///
/// Each blob is characterized by its MIME type (like `"text/plain"`,
/// `"image/png"`, etc.) and the actual content in the form of a string.
///
/// This class has a factory constructor that constructs a `GenerativeContentBlob`
/// object from a JSON object. It also has a method `toJson` that converts
/// a [GenerativeContentBlob] object into a JSON object.
final class GenerativeContentBlob {
  /// The MIME type of the blob.
  final String mimeType;

  /// The actual content of the blob.
  final String data;

  /// Constructs a new `GenerativeContentBlob` object.
  ///
  /// Both the MIME type and the data must be provided.
  GenerativeContentBlob({required this.mimeType, required this.data});

  /// Constructs a `GenerativeContentBlob` from a JSON object.
  ///
  /// The JSON object must have `"mimeType"` and `"data"` keys.
  factory GenerativeContentBlob.fromJson(final Map<String, dynamic> json) =>
      GenerativeContentBlob(
          mimeType: json["mimeType"] as String, data: json["data"] as String);

  /// Converts the `GenerativeContentBlob` object into a JSON object.
  Map<String, dynamic> toJson() => {'mimeType': mimeType, 'data': data};
}

/// The abstract base class [Part].
///
/// This class is the base for other classes and contains some common properties
/// like [Part.text] and [Part.inlineData] and methods such as [Part.fromJson]
/// and [Part.toJson] used in its derived classes.
abstract class Part {
  /// An optional string that describes the part.
  ///
  /// It is handled in the [fromJson] factory constructor. Can be `null`.
  final String? text;

  /// An optional [GenerativeContentBlob] that may be inline with part.
  ///
  /// It is handled in the [fromJson] factory constructor. Can be `null`.
  final GenerativeContentBlob? inlineData;

  /// The private constructor.
  ///
  /// It is not meant to be used directly, instead use the factory constructor
  /// [Part.fromJson].
  Part._({this.text, this.inlineData});

  /// Factory constructor for creating instances of [Part] from a JSON object.
  ///
  /// This method will create either a `TextPart` or an `InlineDataPart` based on
  /// provided [json]. If both `text` and `inlineData` in the [json] are
  /// `null`, it will raise an AssertionError.
  factory Part.fromJson(Map<String, dynamic> json) {
    if (json["text"] != null) {
      return TextPart(json["text"] as String);
    }
    if (json["inlineData"] != null) {
      return InlineDataPart(GenerativeContentBlob.fromJson(
          json["inlineData"] as Map<String, dynamic>));
    }
    throw AssertionError("Both Text and Inline Data can't be null");
  }

  /// Method for serializing the [Part] object to a JSON map.
  ///
  /// Returns a [Map<String, dynamic>] which includes the [text] and
  /// [inlineData].
  Map<String, dynamic> toJson() =>
      {'text': text, 'inlineData': inlineData?.toJson()};
}

/// [TextPart] is a final class which extends from the [Part] class. It represents
/// a section of text, with the text being derived from the super class.
final class TextPart extends Part {
  /// Overridden getter method to get the [text] from the super class.
  /// It is assumed that the super class's [text] will not be null.
  @override
  String get text => super.text!;

  /// Constructor for [TextPart] which takes a [String] as an input and calls the
  /// constructor from the super class with the input text.
  TextPart(final String text) : super._(text: text);
}

/// [InlineDataPart] is a final class which extends from the [Part] class. It
/// represents an inline data part, with the inline data being derived from
/// the super class.
final class InlineDataPart extends Part {
  /// Overridden getter method to get the [inlineData] from the super class.
  /// It is assumed that the super class's [inlineData] will not be null.
  @override
  GenerativeContentBlob get inlineData => super.inlineData!;

  /// Constructor for [InlineDataPart] which takes a [GenerativeContentBlob] as
  /// an input and calls the constructor from the super class with the input
  /// inline data.
  InlineDataPart(final GenerativeContentBlob inlineData)
      : super._(inlineData: inlineData);
}

/// [Content] is a final class which extends [InputContent].
/// It overrides the [parts] getter to return a [List<Part]>] instead.
///
/// It has a constructor which requires a [List<Part>] and a [role],
/// both of which are forwarded to the super constructor.
///
/// It has a factory method [Content.fromJson] which constructs a [Content]
/// object from a JSON map. The [parts] field is extracted and
/// each part is constructed using the [Part.fromJson] method.
///
/// The [toJson] method is overridden to convert the current
/// [Content] object into a JSON map.
final class Content extends InputContent {
  @override

  /// Override the [parts] getter to return a [List<Part>] instead.
  List<Part> get parts => super.parts as List<Part>;

  /// Constructor for [Content]. Takes required parameters for [parts] and [role].
  Content({required List<Part> super.parts, required super.role}) : super._();

  /// Factory method to create a [Content] object from a JSON Map. It maps
  /// each part in the parts list to [Part] object using [Part.fromJson]
  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
        parts: (json["parts"] as List<dynamic>)
            .map((final part) => Part.fromJson(part as Map<String, dynamic>))
            .toList(),
        role: json["role"] as String);
  }

  @override

  /// Convert the [Content] object into a JSON map. It maps each part
  /// in the parts list to a raw map using [Part.toJson]
  Map<String, dynamic> toJson() {
    return {"parts": parts.map((e) => e.toJson()).toList(), "role": role};
  }
}

/// The base class [InputContent].
///
/// Utilized for managing [parts] which can be either `string` or
/// `List<String | Part>` and a [role].
class InputContent {
  /// Can be either `string` or `List<String | Part>`
  final dynamic parts;

  /// Represents the [role]
  final String role;

  /// Default constructor, setting [parts] and [role] as required parameters.
  InputContent._({required this.parts, required this.role});

  /// Constructor that defines an instance of [InputContent] from a `string`
  /// [part] and a [role].
  InputContent.fromString({required final String part, required this.role})
      : parts = part;

  /// Constructor that defines an instance of [InputContent] from a `List` of
  /// [parts] and a [role]. It throws an [AssertionError] if any part is not
  /// a [String] or [Part].
  InputContent.fromList(
      {required List<dynamic> this.parts, required this.role}) {
    if ((parts as List<dynamic>).any((e) => !(e is String || e is Part))) {
      throw AssertionError(
          "Parts can only contain either String or Part data type.");
    }
  }

  /// Factory constructor to create an instance of [InputContent] from a [json]
  /// map.
  factory InputContent.fromJson(Map<String, dynamic> json) {
    final partsJson = json["parts"];
    final role = json["role"] as String;

    if (partsJson is String) {
      return InputContent.fromString(part: partsJson, role: role);
    }

    final parts = [];

    for (final part in (partsJson as List<dynamic>)) {
      if (part is String) {
        parts.add(part);
      } else {
        parts.add(Part.fromJson(part as Map<String, dynamic>));
      }
    }

    return InputContent.fromList(parts: parts, role: role);
  }

  /// Private method to convert _parts to JSON.
  dynamic _partsToJson() {
    if (parts is String) {
      return parts;
    }

    final partsJson = [];
    if (parts is List<dynamic>) {
      for (final part in (parts as List<dynamic>)) {
        if (part is String) {
          partsJson.add(part);
          continue;
        } else {
          partsJson.add((part as Part).toJson());
        }
      }
    }

    return partsJson;
  }

  /// Converts `this` to a `Map<String, dynamic>` that can be encoded into
  /// JSON.
  Map<String, dynamic> toJson() {
    return {"parts": _partsToJson(), "role": role};
  }
}

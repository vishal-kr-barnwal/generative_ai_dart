import 'dart:convert';
import 'dart:typed_data';

import 'package:mime/mime.dart';

/// This class represents a content blob with a specific MIME type and data.
/// Each blob is characterized by its MIME type (like `"text/plain"`,
/// `"image/png"`, etc.) and the actual content in the form of a string.
/// This class has a factory constructor [GenerativeContentBlob.fromJson] that
/// constructs a `GenerativeContentBlob` object from a JSON object. It also has
/// a method [toJson] that converts a [GenerativeContentBlob] object into a JSON object.
class GenerativeContentBlob {
  /// A final string representing the MIME type of the blob
  final String mimeType;

  /// A final string representing the actual content of the blob
  final String data;

  /// Constructs a new [GenerativeContentBlob] object with MIME type and data
  GenerativeContentBlob({required this.mimeType, required this.data});

  /// Factory method that returns a [GenerativeContentBlob] object from a JSON object.
  /// The JSON object must have `"mimeType"` and `"data"` keys.
  factory GenerativeContentBlob.fromJson(Map<String, dynamic> json) =>
      GenerativeContentBlob(mimeType: json["mimeType"], data: json["data"]);

  /// Converts an instance of [GenerativeContentBlob] into a JSON object.
  Map<String, dynamic> toJson() => {'mimeType': mimeType, 'data': data};
}

/// [Part] is an abstract base class and it is used as a common ancestor for
/// other classes. It provides common properties such as [text] and [inlineData]
/// and also methods like [Part.fromJson] and [Part.toJson].
abstract class Part {
  /// An optional [text] which describes the part
  final String? text;

  /// An optional [inlineData] which may be inserted
  /// into the part.
  final GenerativeContentBlob? inlineData;

  /// A private constructor which is only used inside the class.
  Part._({this.text, this.inlineData});

  /// Factory method which helps to create instances of [Part] from a
  /// JSON data structure.
  ///
  /// Can create either [TextPart] or [InlineDataPart] depending on the
  /// [text] and [inlineData] fields in [json]. If both fields are null,
  /// it throws an [AssertionError].
  factory Part.fromJson(Map<String, dynamic> json) {
    if (json["text"] != null) {
      return TextPart._(json["text"]);
    }
    if (json["inlineData"] != null) {
      return InlineDataPart._(
          GenerativeContentBlob.fromJson(json["inlineData"]));
    }
    throw AssertionError("Both Text and Inline Data can't be null");
  }

  /// Factory method which helps to create instances of [Part] from a
  /// [String].
  factory Part.text(String text) => TextPart._(text);

  /// Factory method which helps to create instances of [Part] from a
  /// [GenerativeContentBlob].
  factory Part.inline(GenerativeContentBlob blob) => InlineDataPart._(blob);

  /// Synchronously reads a [File] and returns an instance of [Part].
  factory Part.blob(Uint8List bytes) => InlineDataPart._fromBytes(bytes);

  /// Serializes the [Part] object into a JSON data structure.
  Map<String, dynamic> toJson() => {
        if (text != null) 'text': text,
        if (inlineData != null) 'inlineData': inlineData?.toJson(),
      };
}

/// This final class [TextPart] extends from the [Part] class. It represents a section of
/// text, with the text being derived from the super class.
class TextPart extends Part {
  /// A getter to get the [text] from the base class, assumed not null
  @override
  String get text => super.text!;

  /// Constructor for [TextPart] that takes a string as an input and calls the
  /// internal constructor from the base class with the input text
  TextPart._(String text) : super._(text: text);
}

/// This final class [InlineDataPart] extends from the [Part] class. It represents an inline
/// data part, with the inline data being derived from the super class.
class InlineDataPart extends Part {
  /// A getter to get the [inlineData] from the base class, assumed not null
  @override
  GenerativeContentBlob get inlineData => super.inlineData!;

  /// Constructor for [InlineDataPart] that takes a [GenerativeContentBlob] as
  /// an input and calls the internal constructor from the base class with the input
  /// inline data.
  InlineDataPart._(GenerativeContentBlob inlineData)
      : super._(inlineData: inlineData);

  factory InlineDataPart._fromBytes(Uint8List bytes) {
    final mimeType = lookupMimeType('', headerBytes: bytes)!;

    return InlineDataPart._(
        GenerativeContentBlob(mimeType: mimeType, data: base64Encode(bytes)));
  }
}

/// This final class [Content] represents a list of [Part] instances.
///
/// This class provides a constructor to create a [Content] object with a list
/// of [Part], a role, and factory methods [Content.user] and [Content.model] to
/// create an instance of [Content].
class Content {
  final List<Part> parts;
  final String? role;

  /// Construct a [Content] object;
  Content._({required this.parts, required this.role});

  /// Factory method to create a [Content] object from a JSON object that
  /// contains a 'parts' field, where each part is constructed using
  /// the [Part.fromJson] method.
  ///
  /// If 'parts' field is of type [String], then covert it to [TextPart]
  /// and, add it to [parts]
  factory Content.fromJson(Map<String, dynamic> json) {
    final partsJson = json["parts"];

    final parts = <Part>[];

    if (partsJson is String) {
      parts.add(TextPart._(partsJson));
    } else {
      partsJson?.forEach((partJson) {
        parts.add(Part.fromJson(partJson));
      });
    }

    return Content._(parts: parts, role: json["role"] as String?);
  }

  /// Factory method to create a user [Content] object.
  Content.user(this.parts) : role = "user";

  /// Factory method to create a model [Content] object.
  Content.model(this.parts) : role = "model";

  /// Converts the current [Content] object into a JSON object.
  Map<String, dynamic> toJson() => {
        "parts": parts.map((e) => e.toJson()).toList(),
        if (role != null) "role": role
      };
}

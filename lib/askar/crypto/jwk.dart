import 'dart:convert';
import 'dart:typed_data';

/// A class presents a JSON Web Key (JWK).
///
/// This class provides methods to create a JWK from JSON, convert it to a JSON string,
/// and convert it to a byte array.
class Jwk {
  final String kty;
  final String crv;
  final String x;
  final String? d;
  final String? y;

  /// Constructs an instance of [Jwk].
  Jwk({required this.kty, required this.crv, required this.x, this.d, this.y});

  /// Creates a [Jwk] instance from a JSON map.
  ///
  /// The [json] parameter is a map containing the JWK properties.
  factory Jwk.fromJson(Map<String, dynamic> json) {
    return Jwk(
      kty: json['kty'],
      crv: json['crv'],
      x: json['x'],
      d: json['d'],
      y: json['y'],
    );
  }

  /// Creates a [Jwk] instance from a JSON string.
  ///
  /// The [str] parameter is a JSON string containing the JWK properties.
  factory Jwk.fromString(String str) {
    return Jwk.fromJson(jsonDecode(str));
  }

  /// Converts the JWK to a byte array.
  ///
  /// Returns a [Uint8List] containing the JSON-encoded JWK.
  Uint8List toUint8Array() {
    return Uint8List.fromList(utf8.encode(jsonEncode(toJson())));
  }

  /// Converts the JWK to a JSON map.
  ///
  /// Returns a map containing the JWK properties.
  Map<String, dynamic> toJson() {
    return {
      'kty': kty,
      'crv': crv,
      'x': x,
      'd': d,
      'y': y,
    };
  }
}

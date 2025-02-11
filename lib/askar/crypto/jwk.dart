import 'dart:convert';
import 'dart:typed_data';

class Jwk {
  final String kty;
  final String crv;
  final String x;
  final String? d;
  final String? y;

  Jwk({required this.kty, required this.crv, required this.x, this.d, this.y});

  factory Jwk.fromJson(Map<String, dynamic> json) {
    return Jwk(
      kty: json['kty'],
      crv: json['crv'],
      x: json['x'],
      d: json['d'],
      y: json['y'],
    );
  }

  factory Jwk.fromString(String str) {
    return Jwk.fromJson(jsonDecode(str));
  }

  Uint8List toUint8Array() {
    return Uint8List.fromList(utf8.encode(jsonEncode(toJson())));
  }

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

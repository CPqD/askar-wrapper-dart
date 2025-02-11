import 'dart:convert';
import 'dart:typed_data';

class AskarJwk {
  final String kty;
  final String crv;
  final String x;
  final String? d;
  final String? y;

  AskarJwk({required this.kty, required this.crv, required this.x, this.d, this.y});

  factory AskarJwk.fromJson(Map<String, dynamic> json) {
    return AskarJwk(
      kty: json['kty'],
      crv: json['crv'],
      x: json['x'],
      d: json['d'],
      y: json['y'],
    );
  }

  factory AskarJwk.fromString(String str) {
    return AskarJwk.fromJson(jsonDecode(str));
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

import '../askar_native_functions.dart';

final class AeadParams {
  final int tagLength;
  final int nonceLength;

  AeadParams(this.tagLength, this.nonceLength);

  @override
  String toString() {
    return "AeadParams(tag: $tagLength, pos: $nonceLength)";
  }
}

AeadParams readNativAeadParams(NativeAeadParams aeadParams) {
  int tagLength = aeadParams.tag_length;
  int nonceLength = aeadParams.nonce_length;

  return AeadParams(tagLength, nonceLength);
}

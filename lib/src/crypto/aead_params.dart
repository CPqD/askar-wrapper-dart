import '../askar_native_functions.dart';

/// A class presents a byte buffer combining the AEAD (Authenticated Encryption with Associated Data) parameters.
///
/// This class holds the parameters required for AEAD, including the [tagLength] and [nonceLength].
final class AeadParams {
  /// The length of the authentication tag in bytes.
  ///
  /// This value is used to verify the integrity and authenticity of the encrypted data.
  final int tagLength;

  /// The length of the nonce in bytes.
  ///
  /// The nonce is a unique value for each encryption operation to ensure security.
  final int nonceLength;

  /// Constructs an instance of [AeadParams] with the given [tagLength] and [nonceLength].
  ///
  /// Both [tagLength] and [nonceLength] must be positive integers.
  AeadParams(this.tagLength, this.nonceLength);

  @override
  String toString() {
    return "AeadParams(tag: $tagLength, pos: $nonceLength)";
  }
}

/// Reads native AEAD parameters and returns an [AeadParams] instance.
///
/// This function extracts the tag length and nonce length from the given [NativeAeadParams]
/// and creates an [AeadParams] object with these values.
///
/// - **Parameters**:
///   - [aeadParams]: The native AEAD parameters to read.
/// - **Returns**: An [AeadParams] instance with the extracted tag and nonce lengths.
AeadParams readNativeAeadParams(NativeAeadParams aeadParams) {
  int tagLength = aeadParams.tag_length;
  int nonceLength = aeadParams.nonce_length;

  return AeadParams(tagLength, nonceLength);
}

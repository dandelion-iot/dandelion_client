import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:pointycastle/export.dart';

final class ECDHSecureRandom implements SecureRandom {
  @override
  String get algorithmName => 'ECDHSecureRandom';

  @override
  int nextUint8() => Random().nextInt(1024);

  @override
  BigInt nextBigInteger(int bitLength) {
    // TODO: implement nextBigInteger
    throw UnimplementedError();
  }

  @override
  Uint8List nextBytes(int count) {
    // TODO: implement nextBytes
    throw UnimplementedError();
  }

  @override
  int nextUint16() {
    // TODO: implement nextUint16
    throw UnimplementedError();
  }

  @override
  int nextUint32() {
    // TODO: implement nextUint32
    throw UnimplementedError();
  }

  @override
  void seed(CipherParameters params) {
    // TODO: implement seed
  }
}

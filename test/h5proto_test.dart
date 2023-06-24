import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:dandelion_client/protobuf/MessageStructure.pb.dart';
import 'package:dandelion_client/protobuf/google/protobuf/timestamp.pb.dart';
import 'package:dandelion_client/service/h5proto.dart';
import 'package:fixnum/src/int64.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pointycastle/export.dart';

void main() {
  group("Test H5Proto", () {
    H5Proto proto = H5Proto.init();
    test("generate shared secret", () async {
      var exportPublicKey = proto.exportPublicKey();
      print(exportPublicKey);
      print(exportPublicKey.replaceAll('-----BEGIN PUBLIC KEY-----', '').replaceAll('-----END PUBLIC KEY-----', '').replaceAll('\n', ''));
    });

    test("Check AES Encryption", () async {
      String key = "C+peek3gWNhAbbbNEFzHExU6zbPKhHNDuL0BNa0C4bs=";
      String iv = "iaYN+UpcJVhP6OoUSNLxSg==";
      String data = "Hello World, Hello World, Hello World";


      final cipher = GCMBlockCipher(AESEngine());
      var params = AEADParameters(KeyParameter(base64Decode(key)), 128, base64Decode(iv), Uint8List(0));

      cipher.init(true, params);

      var encValue = cipher.process(Uint8List.fromList(utf8.encode(data)));
      print(base64.encode(encValue));
    });

    test("Check PBKDF2", () async {
      var salt = utf8.encode("123456");
      var sharedSecret = "w56T1bkFIhR8SYc1z5VnqbKtkorRzTOB/AAPdSvudUM=";

      const iterationCount = 1000;
      final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(),64));
      final params = Pbkdf2Parameters(Uint8List.fromList(salt), iterationCount, 32);
      pbkdf2.init(params);
      var result = pbkdf2.process(Uint8List.fromList(utf8.encode(sharedSecret)));
      print(base64Encode(result));
    });
  });
}

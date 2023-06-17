import 'package:dandelion_client/service/h5proto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Test H5Proto", () {
    test("generate shared secret", () async {
      H5Proto proto = H5Proto.init();
      var exportPublicKey = proto.exportPublicKey();
      print(exportPublicKey);
      print(exportPublicKey.replaceAll('-----BEGIN PUBLIC KEY-----', '').replaceAll('-----END PUBLIC KEY-----', '').replaceAll('\n', ''));
    });
  });
}

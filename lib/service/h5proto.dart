import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/protobuf/MessageStructure.pb.dart';
import 'package:dandelion_client/protobuf/google/protobuf/timestamp.pb.dart';
import 'package:pointycastle/export.dart';

class H5Proto {
  late final AsymmetricKeyPair _keyPair;
  late final ECDomainParameters _domainParameters;

  H5Proto.init() {
    _domainParameters = ECDomainParameters(ECCurve_prime256v1().domainName);
    var ecParams = ECKeyGeneratorParameters(_domainParameters);
    var params = ParametersWithRandom<ECKeyGeneratorParameters>(ecParams, getSecureRandom());

    var keyGenerator = ECKeyGenerator();
    keyGenerator.init(params);
    _keyPair = keyGenerator.generateKeyPair();
  }

  ECPublicKey _getPublicKey() {
    return _keyPair.publicKey as ECPublicKey;
  }

  ECPrivateKey _getPrivateKey() {
    return _keyPair.privateKey as ECPrivateKey;
  }

  String exportPublicKey() {
    var pem = CryptoUtils.encodeEcPublicKeyToPem(_getPublicKey());
    return pem.replaceAll('-----BEGIN PUBLIC KEY-----', '')
        .replaceAll('-----END PUBLIC KEY-----', '')
        .replaceAll('\n', '');
  }

  ECPublicKey bytesToPublicKey(Uint8List bytes) {
    return CryptoUtils.ecPublicKeyFromDerBytes(bytes);
  }

  BigInt makeSharedSecret(ECPublicKey remotePublicKey) {
    var agreement = ECDHBasicAgreement();
    agreement.init(_getPrivateKey());
    return agreement.calculateAgreement(remotePublicKey);
  }

  static Uint8List _generateIv() {
    var random = Random.secure();
    return Uint8List.fromList(List.generate(16, (index) => random.nextInt(256)));
  }

  static bigIntToUint8Array(BigInt bigInt) {
    int byteCount = (bigInt.bitLength + 7) ~/ 8;
    Uint8List bytes = Uint8List(byteCount);
    for (int i = byteCount - 1; i >= 0; i--) {
      bytes[i] = bigInt.toUnsigned(8).toInt();
      bigInt = bigInt >> 8;
    }
    return bytes;
  }

  static Uint8List _getKey() {
    var sharedSecret = bigIntToUint8Array(BigInt.parse(prefs.getString('shared-secret')!));
    var saltB64 = prefs.getString('salt');
    if (saltB64 != null) {
      //FIXME , should use pbkdf2
      var salt = base64Decode(saltB64);
      Uint8List key = Uint8List(sharedSecret.length + salt.length);
      key.setRange(0, sharedSecret.length, sharedSecret);
      key.setRange(sharedSecret.length, salt.length, salt);
      return key;
    } else {
      print('Shared Secret: ${base64.encode(sharedSecret)}');
      return sharedSecret;
    }
  }

  static Uint8List encrypt(Uint8List bytes, Uint8List iv) {
    var key = _getKey();
    var aesEngine = AESEngine();
    var params = AEADParameters(KeyParameter(key), 128, iv, Uint8List(0));
    aesEngine.init(true, params.parameters);
    return aesEngine.process(bytes);
  }

  static Uint8List decrypt(Uint8List bytes, Uint8List iv) {
    var key = _getKey();
    var aesEngine = AESEngine();
    var params = AEADParameters(KeyParameter(key), 128, iv, Uint8List(0));
    aesEngine.init(false, params.parameters);
    return aesEngine.process(bytes);
  }

  static Uint8List sha256(Uint8List data) {
    var sha256digest = SHA256Digest();
    return sha256digest.process(data);
  }

  static bool checkSha256(Uint8List data, Uint8List hash) {
    var sha256digest = SHA256Digest();
    var newHash = sha256digest.process(data);
    return newHash.toString() == hash.toString();
  }

  static Future<Packet> serialize(String content, RPC rpc) async {
    var authKeyId = base64Decode(prefs.getString('auth_key_id')!);
    Message message = Message(content: utf8.encode(content), date: Timestamp.create());

    var hash = sha256(message.writeToBuffer());
    var iv = _generateIv();
    var enc = encrypt(message.writeToBuffer(), iv);

    print('Message : ${base64.encode(message.writeToBuffer())}');
    print("Encrypted : ${base64.encode(enc)}");
    print("IV : ${base64.encode(iv)}");

    return Packet(authKeyId: authKeyId,
        rpc: rpc,
        hash: hash,
        iv: iv,
        message: enc);
  }

  static Future<Message> deserialize(Uint8List bytes, Uint8List iv) async {
    var dec = decrypt(bytes, iv);
    return Message.fromBuffer(dec);
  }

  SecureRandom getSecureRandom() {
    var secureRandom = FortunaRandom();
    var random = Random.secure();
    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  Uint8List generateAuthKeyId() {
    final random = Random.secure();
    final bytes = Uint8List(8);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = random.nextInt(256);
    }
    return bytes;
  }
}

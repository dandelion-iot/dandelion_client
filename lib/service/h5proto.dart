import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/protobuf/MessageStructure.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:pointycastle/export.dart';

class H5Proto {
  late final AsymmetricKeyPair _keyPair;
  late final ECDomainParameters _domainParameters;
  late final ECPrivateKey _privateKey;

  H5Proto.init() {
    _domainParameters = ECDomainParameters(ECCurve_prime256v1().domainName);
    var ecParams = ECKeyGeneratorParameters(_domainParameters);
    var params = ParametersWithRandom<ECKeyGeneratorParameters>(ecParams, getSecureRandom());

    var keyGenerator = ECKeyGenerator();
    keyGenerator.init(params);
    _keyPair = keyGenerator.generateKeyPair();
  }

  H5Proto.load() {
    _privateKey = CryptoUtils.ecPrivateKeyFromPem(prefs.getString('private-key')!);
  }

  ECPublicKey _getPublicKey() {
    return _keyPair.publicKey as ECPublicKey;
  }

  ECPrivateKey _getPrivateKey() {
    return _privateKey;
  }

  String exportPublicKey() {
    var pem = CryptoUtils.encodeEcPublicKeyToPem(_getPublicKey());
    return pem.replaceAll('-----BEGIN PUBLIC KEY-----', '').replaceAll('-----END PUBLIC KEY-----', '').replaceAll('\n', '');
  }

  String exportPrivateKey() {
    return CryptoUtils.encodeEcPrivateKeyToPem(_keyPair.privateKey as ECPrivateKey);
  }

  ECPublicKey bytesToPublicKey(Uint8List bytes) {
    return CryptoUtils.ecPublicKeyFromDerBytes(bytes);
  }

  Uint8List makeSharedSecret(ECPublicKey remotePublicKey) {
    var agreement = ECDHBasicAgreement();
    agreement.init(_getPrivateKey());
    var value = agreement.calculateAgreement(remotePublicKey);
    return CryptoUtils.i2osp(value);
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
    var sharedSecret = prefs.getString('shared-secret')!;
    var saltB64 = prefs.getString('activation-key');
    if (saltB64 != null) {
      const iterationCount = 1000;
      var salt = base64Decode(saltB64);

      final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
      final params = Pbkdf2Parameters(Uint8List.fromList(salt), iterationCount, 32);
      pbkdf2.init(params);
      return pbkdf2.process(Uint8List.fromList(utf8.encode(sharedSecret)));
    } else {
      return base64Decode(sharedSecret);
    }
  }

  static Uint8List encrypt(Uint8List bytes, Uint8List iv) {
    var key = _getKey();
    final cipher = GCMBlockCipher(AESEngine());
    var params = AEADParameters(KeyParameter(key), 128, iv, Uint8List(0));
    cipher.init(true, params);
    return cipher.process(bytes);
  }

  static Uint8List decrypt(Uint8List bytes, Uint8List iv) {
    var key = _getKey();
    final cipher = GCMBlockCipher(AESEngine());
    var params = AEADParameters(KeyParameter(key), 128, iv, Uint8List(0));
    cipher.init(false, params);
    return cipher.process(bytes);
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

  static Future<Packet> encode(Uint8List content, RPC rpc) async {
    var deviceId = utf8.encode(getDeviceId()!);
    Message message = Message();
    message.content = content;
    message.timestamp = getCurrentTimestamp();

    var hash = sha256(message.writeToBuffer());
    var iv = _generateIv();
    var enc = encrypt(message.writeToBuffer(), iv);

    Packet packet = Packet();
    packet.deviceId = deviceId;
    packet.rpc = rpc;
    packet.hash = hash;
    packet.iv = iv;
    packet.message = enc;
    return packet;
  }

  static Future<Message> decode(Uint8List bytes, Uint8List iv) async {
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

  static Int64 getCurrentTimestamp() {
     return Int64(DateTime.now().millisecondsSinceEpoch);
  }

  static void storeSharedSecret(Uint8List sharedSecret) {
    prefs.setString('shared-secret', base64Encode(sharedSecret));
  }

  static void storeActivationKey(String activationKey) {
    prefs.setString('activation-key', base64Encode(utf8.encode(activationKey)));
  }

  static void storeDeviceId(String deviceId) {
    prefs.setString('device-id', deviceId);
  }

  static void invalidateCredentials() {
    var deviceId = prefs.getString('device-id');
    if (deviceId == null || deviceId.isEmpty) prefs.remove('device-id');
    prefs.remove('shared-secret');
    prefs.remove('activation-key');
  }

  static void removePrivateKey() {
    prefs.remove('private-key');
  }

  static String? getSharedSecret() {
    var sharedSecret = prefs.getString('shared-secret');
    if (sharedSecret != null && sharedSecret.isEmpty) return null;
    return sharedSecret;
  }

  static String? getActivationKey() {
    var activationKey = prefs.getString('activation-key');
    if (activationKey == null || activationKey.isEmpty) return null;
    return utf8.decode(base64Decode(activationKey));
  }

  static String? getDeviceId() {
    return prefs.getString('device-id');
  }
}

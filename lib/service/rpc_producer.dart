import 'dart:convert';
import 'dart:typed_data';

import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/protobuf/MessageStructure.pb.dart';
import 'package:dandelion_client/service/h5proto.dart';
import 'package:dandelion_client/service/rest_client.dart';

class RPCProducer {
  static Future<void> sendPublicKey() async {
    H5Proto.invalidateCredentials();
    final h5proto = H5Proto.init();

    /* store private key until receive remote public key */
    var exportPrivateKey = h5proto.exportPrivateKey();
    prefs.setString('private-key', exportPrivateKey);

    /* generate random auth-key-id */
    var authKeyId = h5proto.generateAuthKeyId();
    H5Proto.storeAuthKeyId(base64Encode(authKeyId));

    /* export public key */
    var publicKey = h5proto.exportPublicKey();

    Message message = Message();
    message.content = base64Decode(publicKey);

    Packet packet = Packet();
    packet.message = message.writeToBuffer();
    packet.rpc = RPC.RPC_PUBLIC_KEY;
    packet.authKeyId = authKeyId;

    await RestClient.sendPacket(packet);
  }

  static Future<void> sendActivationKey(String activationKey) async {
    H5Proto.storeActivationKey(activationKey);
    await RestClient.rpcCall(Uint8List.fromList(utf8.encode(activationKey)), RPC.RPC_ACTIVATION_KEY);
  }

  static Future<void> sendAuthIdentity(String identity) async {
    await RestClient.rpcCall(Uint8List.fromList(utf8.encode(identity)), RPC.RPC_IDENTITY_AUTH);
  }
}

import 'dart:typed_data';

import 'package:dandelion_client/protobuf/MessageStructure.pb.dart';
import 'package:dandelion_client/service/h5proto.dart';
import 'package:dandelion_client/service/rpc_producer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RPCConsumer {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void apply(Response response) {
    var statusCode = response.statusCode;
    if (statusCode == 200 && response.bodyBytes.isNotEmpty) {
      var body = response.bodyBytes;
      var packet = Packet.fromBuffer(body);
      var message = Message.fromBuffer(packet.message);

      var iv = packet.iv;
      var hash = packet.hash;
      var rpc = packet.rpc;

      switch (rpc) {
        case RPC.RPC_PUBLIC_KEY:
          _initPublicKey(message);
          break;
        case RPC.RPC_IDENTITY_INVALID:
          _invalidIdentity();
          break;
        case RPC.RPC_ACTIVATION_KEY_INVALID:
          _invalidActivationKey();
          break;
        case RPC.RPC_ACTIVATION_KEY_VALID:
          _activationKeyValid();
          break;
        case RPC.RPC_HANDSHAKE_ERROR:
          _handshakeError();
          break;
        default:
          print('Unknown rpc $rpc');
      }
    }
  }

  static void _initPublicKey(Message message) {
    print('Receive shared secret');
    var h5proto = H5Proto.load();
    var remotePublicKey = h5proto.bytesToPublicKey(Uint8List.fromList(message.content));
    var secretKey = h5proto.makeSharedSecret(remotePublicKey);
    H5Proto.storeSharedSecret(secretKey);
    H5Proto.removePrivateKey();
  }

  static void _invalidActivationKey() {
    H5Proto.invalidateCredentials();
    navigatorKey.currentState?.pushReplacementNamed('/register');
  }

  static void _activationKeyValid() {
    navigatorKey.currentState?.pushReplacementNamed('/contacts');
  }

  static Future<void> _invalidIdentity() async {
    H5Proto.invalidateCredentials();
    await RPCProducer.sendPublicKey();
    navigatorKey.currentState?.pushReplacementNamed('/register');
  }

  static Future<void> _handshakeError() async {
    H5Proto.invalidateCredentials();
    await RPCProducer.sendPublicKey();
    navigatorKey.currentState?.pushReplacementNamed('/register');
  }
}

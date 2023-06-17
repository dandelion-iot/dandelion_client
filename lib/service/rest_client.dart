import 'dart:convert';
import 'dart:typed_data';

import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/protobuf/MessageStructure.pb.dart';
import 'package:dandelion_client/service/h5proto.dart';
import 'package:http/http.dart' as http;

class RestClient {
  static String rpcPath = '/api/v1/rpc';

  static var headers = {
    'Content-Type': 'application/x-protobuf',
  };

  static Future exchangeECDH() async {
    final h5proto = H5Proto.init();
    var authKeyId = h5proto.generateAuthKeyId();
    prefs.setString('auth_key_id', base64Encode(authKeyId));
    var publicKey = h5proto.exportPublicKey();
    print(publicKey);
    Message message = Message(content: base64Decode(publicKey));
    Packet packet = Packet(message: message.writeToBuffer(), rpc: RPC.RPC_PUBLIC_KEY, authKeyId: authKeyId);

    var body = packet.writeToBuffer();
    var uri = Uri.http(serverBaseUrl, rpcPath);

    final response = await http.post(uri, headers: headers, body: body);
    var responsePacket = Packet.fromBuffer(response.bodyBytes);
    var responseMessage = Message.fromBuffer(responsePacket.message);

    var remotePublicKey = h5proto.bytesToPublicKey(Uint8List.fromList(responseMessage.content));
    var secretKey = h5proto.makeSharedSecret(remotePublicKey);
    prefs.setString('shared-secret', secretKey.toString());
    return response.statusCode == 200 ? true : false;
  }

  static Future rpcCall(String content, RPC rpc) async {
    Packet packet = await H5Proto.serialize(content, rpc);
    var body = packet.writeToBuffer();
    var uri = Uri.http(serverBaseUrl, rpcPath);
    final response = await http.post(uri, headers: headers, body: body);

    print('body : ${response.statusCode}');
    print('body : ${response.body}');
  }
}

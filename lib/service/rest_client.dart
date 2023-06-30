import 'dart:convert';
import 'dart:typed_data';

import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/protobuf/MessageStructure.pb.dart';
import 'package:dandelion_client/service/h5proto.dart';
import 'package:dandelion_client/service/rpc_consumer.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RestClient {
  static String rpcPath = '/api/v1/rpc';

  static var headers = {
    'Content-Type': 'application/x-protobuf',
  };

  static Future<void> sendPacket(Packet packet) async {
    var uri = Uri.http(serverBaseUrl, rpcPath);
    var response = await http.post(uri, headers: headers, body: packet.writeToBuffer());
    RPCConsumer.apply(response);
  }

  static Future<void> rpcCall(Uint8List content, RPC rpc) async {
    Packet packet = await H5Proto.encode(content, rpc);
    var body = packet.writeToBuffer();
    var uri = Uri.http(serverBaseUrl, rpcPath);
    var response = await http.post(uri, headers: headers, body: body);
    RPCConsumer.apply(response);
  }
}

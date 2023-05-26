import 'dart:convert';

import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CallPage extends StatefulWidget {
  final Contact targetContact;
  const CallPage({Key? key, required this.targetContact}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late final WebSocketChannel channel;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  bool isWebsocketConnected = false;
  MediaStream? _localStream;
  RTCPeerConnection? pc;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    await connectSocket();
    await joinRoom();
  }

  Future connectSocket() async {
    var uri = Uri.parse('ws://$serverBaseUrl/webrtc/signal/');
    channel = WebSocketChannel.connect(uri);

    setState(() {
      isWebsocketConnected = channel.closeCode == null && channel.closeReason == null;
    });

    channel.stream.listen((event) async {
      var payload = jsonDecode(event);
      var type = payload['type'];
      print('Receive type: $type');
      switch (type) {
        case 'joined':
          await _sendOffer();
          break;
        case 'offer':
          await _gotOffer(
              RTCSessionDescription(payload['sdp'], payload['type']));
          await _sendAnswer();
          break;
        case 'answer':
          await _gotAnswer(
              RTCSessionDescription(payload['sdp'], payload['type']));
          break;
        case 'ice':
          await _gotIce(RTCIceCandidate(payload['candidate'], payload['sdpMid'],
              payload['sdpMLineIndex']));
          break;
      }
    });
  }

  Future joinRoom() async {
    final config = {
      'iceServers': [
        {"url": "stun:192.168.1.123:3478"},
      ]
    };

    final sdpConstraints = {
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': true,
      },
      'optional': []
    };

    pc = await createPeerConnection(config, sdpConstraints);

    final mediaConstraints = {
      'audio': true,
      'video': {'facingMode': 'user'}
    };

    _localStream = await Helper.openCamera(mediaConstraints);

    _localStream!.getTracks().forEach((track) {
      pc!.addTrack(track, _localStream!);
    });

    _localRenderer.srcObject = _localStream;

    pc!.onIceCandidate = (ice) {
      _sendIce(ice);
    };

    pc!.onAddStream = (stream) {
      _remoteRenderer.srcObject = stream;
    };

    var payload = {'type': 'join'};
    channel.sink.add(jsonEncode(payload));
  }

  Future _sendOffer() async {
    print('send offer');
    var offer = await pc!.createOffer();
    pc!.setLocalDescription(offer);
    var payload = {'type': offer.type, 'sdp': offer.sdp};
    channel.sink.add(jsonEncode(payload));
  }

  Future _gotOffer(RTCSessionDescription offer) async {
    print('got offer');
    await pc!.setRemoteDescription(offer);
  }

  Future _sendAnswer() async {
    print('send answer');
    var answer = await pc!.createAnswer();
    pc!.setLocalDescription(answer);
    var payload = {'type': answer.type, 'sdp': answer.sdp};
    channel.sink.add(jsonEncode(payload));
  }

  Future _gotAnswer(RTCSessionDescription answer) async {
    print('got answer');
    await pc!.setRemoteDescription(answer);
  }

  Future _sendIce(RTCIceCandidate ice) async {
    var payload = {
      'type': 'ice',
      'candidate': ice.candidate,
      'sdpMid': ice.sdpMid,
      'sdpMLineIndex': ice.sdpMLineIndex,
    };
    channel.sink.add(jsonEncode(payload));
  }

  Future _gotIce(RTCIceCandidate ice) async {
    await pc!.addCandidate(ice);
  }

  void disconnect() {
    _localStream?.getTracks().forEach((track) => track.stop());
    pc?.close();
    channel.sink.close();
    setState(() {
      isWebsocketConnected = false;
    });
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.blue,
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              RTCVideoView(_localRenderer),
              Positioned(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150,
                        height: 200,
                        child: RTCVideoView(_remoteRenderer),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

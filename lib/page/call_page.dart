import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/model/contact.dart';
import 'package:dandelion_client/service/webrtc_context.dart';
import 'package:dandelion_client/service/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lottie/lottie.dart';
import 'package:wakelock/wakelock.dart';

class CallPage extends StatefulWidget {
  final Contact? targetContact;

  const CallPage({Key? key, required this.targetContact}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late final WebSocketService _ws = WebSocketService();
  late final WebRTCContext _webRTCContext = WebRTCContext();
  final player = AudioPlayer();
  late MediaStream mediaStream;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  bool _isAnswered = true;

  @override
  void initState() {
    print('InitState of CallPage executed');
    Wakelock.enable(); //TODO : enable only for voice
    _ws.setMessageCallback((type, payload) => messageListener(type, payload));
    initRenderers();
    init();

    super.initState();
  }

  void initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future init() async {
    try {
      mediaStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      setState(() {
        _localRenderer.srcObject = mediaStream;
      });
      await _webRTCContext.createConnection(_localRenderer, _remoteRenderer, mediaStream);
      if (widget.targetContact != null) {
        await _webRTCContext.createRoom(widget.targetContact!);
      } else {
        setState(() {
          _isAnswered = false;
        });
        playRing();
      }
    } catch (e) {
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      print('Error initializing: $e');
      print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
    }
  }

  Future messageListener(String type, Map<String, dynamic> payload) async {
    switch (type) {
      case 'joined':
        var room = payload['room'];
        await prefs.setString('room', room);
        await _webRTCContext.sendOffer();
        break;
      case 'offer':
        await _webRTCContext.setRemoteDescription(payload);
        await _webRTCContext.sendAnswer();
        break;
      case 'answer':
        await _webRTCContext.setRemoteDescription(payload);
        break;
      case 'ice':
        await _webRTCContext.setCandidate(payload);
        break;
    }
  }

  Future playRing() async {
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource('ring.mp3'));
  }

  Future answerToCall() async {
    await player.stop();
    await _webRTCContext.sendJoined();
    setState(() {
      _isAnswered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            RTCVideoView(
              _localRenderer,
              placeholderBuilder: (context) {
                return Container(
                  color: Colors.grey,
                  child: Text('Wait for local video ...'),
                );
              },
            ),
            Positioned(
              child: Visibility(
                visible: _isAnswered,
                replacement: Center(
                  child: GestureDetector(
                    onTap: () => answerToCall(),
                    child: Lottie.asset('assets/data.json', repeat: true),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150,
                        height: 200,
                        child: RTCVideoView(
                          _remoteRenderer,
                          placeholderBuilder: (context) {
                            return Container(
                              color: Colors.grey,
                              child: Text('Wait for remote video ...'),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sendHangup() {
    player.stop();
    var room = prefs.getString('room');
    var payload = {'type': 'hangup', 'room': room};
    _ws.send(jsonEncode(payload));
  }

  @override
  void dispose() {
    print('Call page dispose executed');
    mediaStream.getTracks().forEach((track) => {
          track.stop(),
          mediaStream.removeTrack(track),
        });
    mediaStream.dispose();
    _webRTCContext.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _sendHangup();
    Wakelock.disable();
    super.dispose();
  }
}

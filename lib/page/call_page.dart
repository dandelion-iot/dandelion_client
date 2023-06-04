import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/model/contact.dart';
import 'package:dandelion_client/service/webrtc/state/answer_state.dart';
import 'package:dandelion_client/service/webrtc/state/ice_state.dart';
import 'package:dandelion_client/service/webrtc/state/joined_state.dart';
import 'package:dandelion_client/service/webrtc/state/offer_state.dart';
import 'package:dandelion_client/service/webrtc/webrtc_context.dart';
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
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  bool _isLocalRendererInitialized = false;
  bool _isRemoteRendererInitialized = false;
  bool _isAnswered = true;

  @override
  void initState() {
    print('InitState of CallPage executed');
    super.initState();
    Wakelock.enable();
    init();
  }

  Future init() async {
    try {
      MediaStream localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      await _localRenderer.initialize();
      await _webRTCContext.initializeLocalRenderer(_localRenderer, localStream);

      eventListener();

      /*
    * When client try call to contact
    * */
      if (widget.targetContact != null) {
        await _webRTCContext.joinRoom(widget.targetContact);
      } else {
        /*
      * When receive incoming call
      * */
        setState(() {
          _isAnswered = false;
        });
        playRing();
      }

      await Future.delayed(Duration(seconds: 1));

      setState(() {
        _isLocalRendererInitialized = _webRTCContext.isLocalRendererInitialized();
      });
    } catch (e) {
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      print('Error initializing: $e');
      print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
    }
  }

  Future eventListener() async {
    _ws.messageStream.listen((event) async {
      var payload = jsonDecode(event);
      var type = payload['type'];
      print('Receive type: $type');
      switch (type) {
        case 'joined':
          var room = payload['room'];
          await prefs.setString('room', room);

          await _remoteRenderer.initialize();
          await _webRTCContext.initializeRemoteRenderer(_remoteRenderer);
          setState(() {
            _isRemoteRendererInitialized = _webRTCContext.isRemoteRendererInitialized();
          });

          _webRTCContext.handleRequest(RTCJoinedState(), payload);
          break;
        case 'offer':
          _webRTCContext.handleRequest(RTCOfferState(), payload);
          break;
        case 'answer':
          _webRTCContext.handleRequest(RTCAnswerState(), payload);
          break;
        case 'ice':
          _webRTCContext.handleRequest(RTCIceState(), payload);
          break;
      }
    });
  }

  Future playRing() async {
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource('ring.mp3'));
  }

  Future answerToCall() async {
    await _remoteRenderer.initialize();
    await _webRTCContext.initializeRemoteRenderer(_remoteRenderer);

    await _webRTCContext.joined();

    setState(() {
      _isRemoteRendererInitialized = _webRTCContext.isRemoteRendererInitialized();
      _isAnswered = true;
      player.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            if (_isLocalRendererInitialized) RTCVideoView(_localRenderer),
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
                    if (_isRemoteRendererInitialized)
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _webRTCContext.dispose();
    var room = prefs.getString('room');
    var payload = {'type': 'hangup', 'room': room};
    _ws.send(jsonEncode(payload));
    Wakelock.disable();
    super.dispose();
  }
}

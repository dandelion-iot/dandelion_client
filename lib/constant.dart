import 'package:shared_preferences/shared_preferences.dart';

var serverBaseUrl = "192.168.1.123:8080";
var stunServers = {
  "iceServers": [
    {"url": "stun:stun.l.google.com:19302"},
    {"url": "stun:stun.services.mozilla.com:3478"},
    {"url": "stun:stun.voipstunt.com"},
  ]
};

var sdpConstraints = {
  'mandatory': {
    'OfferToReceiveAudio': true,
    'OfferToReceiveVideo': true,
  },
  'optional': []
};

late SharedPreferences prefs;
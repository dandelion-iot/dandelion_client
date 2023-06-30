//
//  Generated code. Do not modify.
//  source: MessageStructure.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RPC extends $pb.ProtobufEnum {
  static const RPC RPC_PUBLIC_KEY = RPC._(0, _omitEnumNames ? '' : 'RPC_PUBLIC_KEY');
  static const RPC RPC_HANDSHAKE_ERROR = RPC._(1, _omitEnumNames ? '' : 'RPC_HANDSHAKE_ERROR');
  static const RPC RPC_IDENTITY_AUTH = RPC._(2, _omitEnumNames ? '' : 'RPC_IDENTITY_AUTH');
  static const RPC RPC_IDENTITY_INVALID = RPC._(3, _omitEnumNames ? '' : 'RPC_IDENTITY_INVALID');
  static const RPC RPC_ACTIVATION_KEY = RPC._(4, _omitEnumNames ? '' : 'RPC_ACTIVATION_KEY');
  static const RPC RPC_ACTIVATION_KEY_INVALID = RPC._(5, _omitEnumNames ? '' : 'RPC_ACTIVATION_KEY_INVALID');
  static const RPC RPC_ACTIVATION_KEY_VALID = RPC._(6, _omitEnumNames ? '' : 'RPC_ACTIVATION_KEY_VALID');
  static const RPC RPC_INVALID_DEVICE_ID = RPC._(7, _omitEnumNames ? '' : 'RPC_INVALID_DEVICE_ID');
  static const RPC RPC_WEBRTC_JOIN = RPC._(8, _omitEnumNames ? '' : 'RPC_WEBRTC_JOIN');
  static const RPC RPC_WEBRTC_JOINED = RPC._(9, _omitEnumNames ? '' : 'RPC_WEBRTC_JOINED');
  static const RPC RPC_WEBRTC_HANGUP = RPC._(10, _omitEnumNames ? '' : 'RPC_WEBRTC_HANGUP');
  static const RPC RPC_WEBRTC_GENERIC = RPC._(11, _omitEnumNames ? '' : 'RPC_WEBRTC_GENERIC');

  static const $core.List<RPC> values = <RPC> [
    RPC_PUBLIC_KEY,
    RPC_HANDSHAKE_ERROR,
    RPC_IDENTITY_AUTH,
    RPC_IDENTITY_INVALID,
    RPC_ACTIVATION_KEY,
    RPC_ACTIVATION_KEY_INVALID,
    RPC_ACTIVATION_KEY_VALID,
    RPC_INVALID_DEVICE_ID,
    RPC_WEBRTC_JOIN,
    RPC_WEBRTC_JOINED,
    RPC_WEBRTC_HANGUP,
    RPC_WEBRTC_GENERIC,
  ];

  static final $core.Map<$core.int, RPC> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RPC? valueOf($core.int value) => _byValue[value];

  const RPC._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');

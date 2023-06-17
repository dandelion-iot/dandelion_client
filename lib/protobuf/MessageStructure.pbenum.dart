///
//  Generated code. Do not modify.
//  source: MessageStructure.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class RPC extends $pb.ProtobufEnum {
  static const RPC RPC_PUBLIC_KEY = RPC._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RPC_PUBLIC_KEY');
  static const RPC RPC_IDENTITY_AUTH = RPC._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RPC_IDENTITY_AUTH');
  static const RPC RPC_IDENTITY_INVALID = RPC._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RPC_IDENTITY_INVALID');
  static const RPC RPC_ACTIVATION_KEY = RPC._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RPC_ACTIVATION_KEY');
  static const RPC RPC_ACTIVATION_KEY_INVALID = RPC._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RPC_ACTIVATION_KEY_INVALID');
  static const RPC RPC_ACTIVATION_KEY_VALID = RPC._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RPC_ACTIVATION_KEY_VALID');

  static const $core.List<RPC> values = <RPC> [
    RPC_PUBLIC_KEY,
    RPC_IDENTITY_AUTH,
    RPC_IDENTITY_INVALID,
    RPC_ACTIVATION_KEY,
    RPC_ACTIVATION_KEY_INVALID,
    RPC_ACTIVATION_KEY_VALID,
  ];

  static final $core.Map<$core.int, RPC> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RPC? valueOf($core.int value) => _byValue[value];

  const RPC._($core.int v, $core.String n) : super(v, n);
}


///
//  Generated code. Do not modify.
//  source: MessageStructure.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use rPCDescriptor instead')
const RPC$json = const {
  '1': 'RPC',
  '2': const [
    const {'1': 'RPC_PUBLIC_KEY', '2': 0},
    const {'1': 'RPC_IDENTITY_AUTH', '2': 1},
    const {'1': 'RPC_IDENTITY_INVALID', '2': 2},
    const {'1': 'RPC_ACTIVATION_KEY', '2': 3},
    const {'1': 'RPC_ACTIVATION_KEY_INVALID', '2': 4},
    const {'1': 'RPC_ACTIVATION_KEY_VALID', '2': 5},
  ],
};

/// Descriptor for `RPC`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List rPCDescriptor = $convert.base64Decode('CgNSUEMSEgoOUlBDX1BVQkxJQ19LRVkQABIVChFSUENfSURFTlRJVFlfQVVUSBABEhgKFFJQQ19JREVOVElUWV9JTlZBTElEEAISFgoSUlBDX0FDVElWQVRJT05fS0VZEAMSHgoaUlBDX0FDVElWQVRJT05fS0VZX0lOVkFMSUQQBBIcChhSUENfQUNUSVZBVElPTl9LRVlfVkFMSUQQBQ==');
@$core.Deprecated('Use messageDescriptor instead')
const Message$json = const {
  '1': 'Message',
  '2': const [
    const {'1': 'content', '3': 1, '4': 1, '5': 12, '10': 'content'},
    const {'1': 'sender', '3': 2, '4': 1, '5': 9, '10': 'sender'},
    const {'1': 'peers', '3': 3, '4': 3, '5': 9, '10': 'peers'},
    const {'1': 'date', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'date'},
    const {'1': 'padding', '3': 5, '4': 3, '5': 12, '10': 'padding'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode('CgdNZXNzYWdlEhgKB2NvbnRlbnQYASABKAxSB2NvbnRlbnQSFgoGc2VuZGVyGAIgASgJUgZzZW5kZXISFAoFcGVlcnMYAyADKAlSBXBlZXJzEi4KBGRhdGUYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRkYXRlEhgKB3BhZGRpbmcYBSADKAxSB3BhZGRpbmc=');
@$core.Deprecated('Use packetDescriptor instead')
const Packet$json = const {
  '1': 'Packet',
  '2': const [
    const {'1': 'auth_key_id', '3': 1, '4': 1, '5': 12, '10': 'authKeyId'},
    const {'1': 'rpc', '3': 2, '4': 1, '5': 14, '6': '.roboexchange.RPC', '10': 'rpc'},
    const {'1': 'hash', '3': 3, '4': 1, '5': 12, '10': 'hash'},
    const {'1': 'iv', '3': 4, '4': 1, '5': 12, '10': 'iv'},
    const {'1': 'message', '3': 5, '4': 1, '5': 12, '10': 'message'},
  ],
};

/// Descriptor for `Packet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packetDescriptor = $convert.base64Decode('CgZQYWNrZXQSHgoLYXV0aF9rZXlfaWQYASABKAxSCWF1dGhLZXlJZBIjCgNycGMYAiABKA4yES5yb2JvZXhjaGFuZ2UuUlBDUgNycGMSEgoEaGFzaBgDIAEoDFIEaGFzaBIOCgJpdhgEIAEoDFICaXYSGAoHbWVzc2FnZRgFIAEoDFIHbWVzc2FnZQ==');

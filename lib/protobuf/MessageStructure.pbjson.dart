//
//  Generated code. Do not modify.
//  source: MessageStructure.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use rPCDescriptor instead')
const RPC$json = {
  '1': 'RPC',
  '2': [
    {'1': 'RPC_PUBLIC_KEY', '2': 0},
    {'1': 'RPC_HANDSHAKE_ERROR', '2': 1},
    {'1': 'RPC_IDENTITY_AUTH', '2': 2},
    {'1': 'RPC_IDENTITY_INVALID', '2': 3},
    {'1': 'RPC_ACTIVATION_KEY', '2': 4},
    {'1': 'RPC_ACTIVATION_KEY_INVALID', '2': 5},
    {'1': 'RPC_ACTIVATION_KEY_VALID', '2': 6},
    {'1': 'RPC_INVALID_DEVICE_ID', '2': 7},
  ],
};

/// Descriptor for `RPC`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List rPCDescriptor = $convert.base64Decode(
    'CgNSUEMSEgoOUlBDX1BVQkxJQ19LRVkQABIXChNSUENfSEFORFNIQUtFX0VSUk9SEAESFQoRUl'
    'BDX0lERU5USVRZX0FVVEgQAhIYChRSUENfSURFTlRJVFlfSU5WQUxJRBADEhYKElJQQ19BQ1RJ'
    'VkFUSU9OX0tFWRAEEh4KGlJQQ19BQ1RJVkFUSU9OX0tFWV9JTlZBTElEEAUSHAoYUlBDX0FDVE'
    'lWQVRJT05fS0VZX1ZBTElEEAYSGQoVUlBDX0lOVkFMSURfREVWSUNFX0lEEAc=');

@$core.Deprecated('Use packetDescriptor instead')
const Packet$json = {
  '1': 'Packet',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 12, '10': 'deviceId'},
    {'1': 'rpc', '3': 2, '4': 1, '5': 14, '6': '.roboexchange.RPC', '10': 'rpc'},
    {'1': 'hash', '3': 3, '4': 1, '5': 12, '10': 'hash'},
    {'1': 'iv', '3': 4, '4': 1, '5': 12, '10': 'iv'},
    {'1': 'message', '3': 5, '4': 1, '5': 12, '10': 'message'},
  ],
};

/// Descriptor for `Packet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packetDescriptor = $convert.base64Decode(
    'CgZQYWNrZXQSGwoJZGV2aWNlX2lkGAEgASgMUghkZXZpY2VJZBIjCgNycGMYAiABKA4yES5yb2'
    'JvZXhjaGFuZ2UuUlBDUgNycGMSEgoEaGFzaBgDIAEoDFIEaGFzaBIOCgJpdhgEIAEoDFICaXYS'
    'GAoHbWVzc2FnZRgFIAEoDFIHbWVzc2FnZQ==');

@$core.Deprecated('Use messageDescriptor instead')
const Message$json = {
  '1': 'Message',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 12, '10': 'content'},
    {'1': 'sender', '3': 2, '4': 1, '5': 9, '10': 'sender'},
    {'1': 'peers', '3': 3, '4': 3, '5': 9, '10': 'peers'},
    {'1': 'date', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'date'},
    {'1': 'padding', '3': 5, '4': 3, '5': 12, '10': 'padding'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode(
    'CgdNZXNzYWdlEhgKB2NvbnRlbnQYASABKAxSB2NvbnRlbnQSFgoGc2VuZGVyGAIgASgJUgZzZW'
    '5kZXISFAoFcGVlcnMYAyADKAlSBXBlZXJzEi4KBGRhdGUYBCABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUgRkYXRlEhgKB3BhZGRpbmcYBSADKAxSB3BhZGRpbmc=');


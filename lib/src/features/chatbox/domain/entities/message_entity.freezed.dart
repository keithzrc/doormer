// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Message {
  /// Unique identifier for the message.
  String get id => throw _privateConstructorUsedError;

  /// The actual content of the message.
  String get content => throw _privateConstructorUsedError;

  /// Timestamp when the message was created.
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Indicates whether the message was sent by the current user.
  bool get isFromMe => throw _privateConstructorUsedError;

  /// The type of the message (text, image, file, etc.).
  MessageType get type => throw _privateConstructorUsedError;

  /// URL for media content (if applicable).
  String? get mediaUrl => throw _privateConstructorUsedError;

  /// Duration for audio messages (if applicable).
  Duration? get audioDuration => throw _privateConstructorUsedError;

  /// The contact ID associated with the message.
  String get contactId => throw _privateConstructorUsedError;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call(
      {String id,
      String content,
      DateTime timestamp,
      bool isFromMe,
      MessageType type,
      String? mediaUrl,
      Duration? audioDuration,
      String contactId});
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? timestamp = null,
    Object? isFromMe = null,
    Object? type = null,
    Object? mediaUrl = freezed,
    Object? audioDuration = freezed,
    Object? contactId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFromMe: null == isFromMe
          ? _value.isFromMe
          : isFromMe // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      audioDuration: freezed == audioDuration
          ? _value.audioDuration
          : audioDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
          _$MessageImpl value, $Res Function(_$MessageImpl) then) =
      __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String content,
      DateTime timestamp,
      bool isFromMe,
      MessageType type,
      String? mediaUrl,
      Duration? audioDuration,
      String contactId});
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
      _$MessageImpl _value, $Res Function(_$MessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? timestamp = null,
    Object? isFromMe = null,
    Object? type = null,
    Object? mediaUrl = freezed,
    Object? audioDuration = freezed,
    Object? contactId = null,
  }) {
    return _then(_$MessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFromMe: null == isFromMe
          ? _value.isFromMe
          : isFromMe // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      audioDuration: freezed == audioDuration
          ? _value.audioDuration
          : audioDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$MessageImpl implements _Message {
  const _$MessageImpl(
      {required this.id,
      required this.content,
      required this.timestamp,
      required this.isFromMe,
      required this.type,
      this.mediaUrl,
      this.audioDuration,
      required this.contactId});

  /// Unique identifier for the message.
  @override
  final String id;

  /// The actual content of the message.
  @override
  final String content;

  /// Timestamp when the message was created.
  @override
  final DateTime timestamp;

  /// Indicates whether the message was sent by the current user.
  @override
  final bool isFromMe;

  /// The type of the message (text, image, file, etc.).
  @override
  final MessageType type;

  /// URL for media content (if applicable).
  @override
  final String? mediaUrl;

  /// Duration for audio messages (if applicable).
  @override
  final Duration? audioDuration;

  /// The contact ID associated with the message.
  @override
  final String contactId;

  @override
  String toString() {
    return 'Message(id: $id, content: $content, timestamp: $timestamp, isFromMe: $isFromMe, type: $type, mediaUrl: $mediaUrl, audioDuration: $audioDuration, contactId: $contactId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isFromMe, isFromMe) ||
                other.isFromMe == isFromMe) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.audioDuration, audioDuration) ||
                other.audioDuration == audioDuration) &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, content, timestamp, isFromMe,
      type, mediaUrl, audioDuration, contactId);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);
}

abstract class _Message implements Message {
  const factory _Message(
      {required final String id,
      required final String content,
      required final DateTime timestamp,
      required final bool isFromMe,
      required final MessageType type,
      final String? mediaUrl,
      final Duration? audioDuration,
      required final String contactId}) = _$MessageImpl;

  /// Unique identifier for the message.
  @override
  String get id;

  /// The actual content of the message.
  @override
  String get content;

  /// Timestamp when the message was created.
  @override
  DateTime get timestamp;

  /// Indicates whether the message was sent by the current user.
  @override
  bool get isFromMe;

  /// The type of the message (text, image, file, etc.).
  @override
  MessageType get type;

  /// URL for media content (if applicable).
  @override
  String? get mediaUrl;

  /// Duration for audio messages (if applicable).
  @override
  Duration? get audioDuration;

  /// The contact ID associated with the message.
  @override
  String get contactId;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

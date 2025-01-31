// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Contact {
  /// Unique numeric identifier for the contact
  int get contactId => throw _privateConstructorUsedError;

  /// Unique identifier for the contact, represented as a UUID.
  UuidValue get id => throw _privateConstructorUsedError;

  /// Name of the user associated with the contact.
  String get userName => throw _privateConstructorUsedError;

  /// URL of the user's avatar image.
  String get avatarUrl => throw _privateConstructorUsedError;

  /// The last message sent or received in the chat associated with the contact.
  String get lastMessage => throw _privateConstructorUsedError;

  /// The timestamp of when the last message was created.
  DateTime get lastMessageCreatedTime => throw _privateConstructorUsedError;

  /// Indicates whether the contact's chat is archived.
  bool get isArchived => throw _privateConstructorUsedError;

  /// Indicates whether the contact's chat has been read.
  bool get isRead => throw _privateConstructorUsedError;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactCopyWith<Contact> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactCopyWith<$Res> {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) then) =
      _$ContactCopyWithImpl<$Res, Contact>;
  @useResult
  $Res call(
      {int contactId,
      UuidValue id,
      String userName,
      String avatarUrl,
      String lastMessage,
      DateTime lastMessageCreatedTime,
      bool isArchived,
      bool isRead});
}

/// @nodoc
class _$ContactCopyWithImpl<$Res, $Val extends Contact>
    implements $ContactCopyWith<$Res> {
  _$ContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactId = null,
    Object? id = null,
    Object? userName = null,
    Object? avatarUrl = null,
    Object? lastMessage = null,
    Object? lastMessageCreatedTime = null,
    Object? isArchived = null,
    Object? isRead = null,
  }) {
    return _then(_value.copyWith(
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as UuidValue,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageCreatedTime: null == lastMessageCreatedTime
          ? _value.lastMessageCreatedTime
          : lastMessageCreatedTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactImplCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory _$$ContactImplCopyWith(
          _$ContactImpl value, $Res Function(_$ContactImpl) then) =
      __$$ContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int contactId,
      UuidValue id,
      String userName,
      String avatarUrl,
      String lastMessage,
      DateTime lastMessageCreatedTime,
      bool isArchived,
      bool isRead});
}

/// @nodoc
class __$$ContactImplCopyWithImpl<$Res>
    extends _$ContactCopyWithImpl<$Res, _$ContactImpl>
    implements _$$ContactImplCopyWith<$Res> {
  __$$ContactImplCopyWithImpl(
      _$ContactImpl _value, $Res Function(_$ContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactId = null,
    Object? id = null,
    Object? userName = null,
    Object? avatarUrl = null,
    Object? lastMessage = null,
    Object? lastMessageCreatedTime = null,
    Object? isArchived = null,
    Object? isRead = null,
  }) {
    return _then(_$ContactImpl(
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as UuidValue,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageCreatedTime: null == lastMessageCreatedTime
          ? _value.lastMessageCreatedTime
          : lastMessageCreatedTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ContactImpl implements _Contact {
  const _$ContactImpl(
      {required this.contactId,
      required this.id,
      required this.userName,
      required this.avatarUrl,
      required this.lastMessage,
      required this.lastMessageCreatedTime,
      required this.isArchived,
      required this.isRead});

  /// Unique numeric identifier for the contact
  @override
  final int contactId;

  /// Unique identifier for the contact, represented as a UUID.
  @override
  final UuidValue id;

  /// Name of the user associated with the contact.
  @override
  final String userName;

  /// URL of the user's avatar image.
  @override
  final String avatarUrl;

  /// The last message sent or received in the chat associated with the contact.
  @override
  final String lastMessage;

  /// The timestamp of when the last message was created.
  @override
  final DateTime lastMessageCreatedTime;

  /// Indicates whether the contact's chat is archived.
  @override
  final bool isArchived;

  /// Indicates whether the contact's chat has been read.
  @override
  final bool isRead;

  @override
  String toString() {
    return 'Contact(contactId: $contactId, id: $id, userName: $userName, avatarUrl: $avatarUrl, lastMessage: $lastMessage, lastMessageCreatedTime: $lastMessageCreatedTime, isArchived: $isArchived, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactImpl &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageCreatedTime, lastMessageCreatedTime) ||
                other.lastMessageCreatedTime == lastMessageCreatedTime) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contactId, id, userName,
      avatarUrl, lastMessage, lastMessageCreatedTime, isArchived, isRead);

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      __$$ContactImplCopyWithImpl<_$ContactImpl>(this, _$identity);
}

abstract class _Contact implements Contact {
  const factory _Contact(
      {required final int contactId,
      required final UuidValue id,
      required final String userName,
      required final String avatarUrl,
      required final String lastMessage,
      required final DateTime lastMessageCreatedTime,
      required final bool isArchived,
      required final bool isRead}) = _$ContactImpl;

  /// Unique numeric identifier for the contact
  @override
  int get contactId;

  /// Unique identifier for the contact, represented as a UUID.
  @override
  UuidValue get id;

  /// Name of the user associated with the contact.
  @override
  String get userName;

  /// URL of the user's avatar image.
  @override
  String get avatarUrl;

  /// The last message sent or received in the chat associated with the contact.
  @override
  String get lastMessage;

  /// The timestamp of when the last message was created.
  @override
  DateTime get lastMessageCreatedTime;

  /// Indicates whether the contact's chat is archived.
  @override
  bool get isArchived;

  /// Indicates whether the contact's chat has been read.
  @override
  bool get isRead;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

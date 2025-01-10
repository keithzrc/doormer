// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_info_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ContactInfo {
  /// Unique identifier for the contact.
  @UuidValueConverter()
  UuidValue get id => throw _privateConstructorUsedError;

  /// Display name of the contact.
  String get name => throw _privateConstructorUsedError;

  /// URL of the contact's avatar image.
  String get avatarUrl => throw _privateConstructorUsedError;

  /// Professional position or role of the contact.
  String? get position => throw _privateConstructorUsedError;

  /// Expected salary range of the contact.
  String? get expectedSalary => throw _privateConstructorUsedError;

  /// Current status of the contact (e.g., 'Active', 'Offline').
  String get status => throw _privateConstructorUsedError;

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactInfoCopyWith<ContactInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactInfoCopyWith<$Res> {
  factory $ContactInfoCopyWith(
          ContactInfo value, $Res Function(ContactInfo) then) =
      _$ContactInfoCopyWithImpl<$Res, ContactInfo>;
  @useResult
  $Res call(
      {@UuidValueConverter() UuidValue id,
      String name,
      String avatarUrl,
      String? position,
      String? expectedSalary,
      String status});
}

/// @nodoc
class _$ContactInfoCopyWithImpl<$Res, $Val extends ContactInfo>
    implements $ContactInfoCopyWith<$Res> {
  _$ContactInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = null,
    Object? position = freezed,
    Object? expectedSalary = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as UuidValue,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedSalary: freezed == expectedSalary
          ? _value.expectedSalary
          : expectedSalary // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactInfoImplCopyWith<$Res>
    implements $ContactInfoCopyWith<$Res> {
  factory _$$ContactInfoImplCopyWith(
          _$ContactInfoImpl value, $Res Function(_$ContactInfoImpl) then) =
      __$$ContactInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@UuidValueConverter() UuidValue id,
      String name,
      String avatarUrl,
      String? position,
      String? expectedSalary,
      String status});
}

/// @nodoc
class __$$ContactInfoImplCopyWithImpl<$Res>
    extends _$ContactInfoCopyWithImpl<$Res, _$ContactInfoImpl>
    implements _$$ContactInfoImplCopyWith<$Res> {
  __$$ContactInfoImplCopyWithImpl(
      _$ContactInfoImpl _value, $Res Function(_$ContactInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = null,
    Object? position = freezed,
    Object? expectedSalary = freezed,
    Object? status = null,
  }) {
    return _then(_$ContactInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as UuidValue,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedSalary: freezed == expectedSalary
          ? _value.expectedSalary
          : expectedSalary // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ContactInfoImpl implements _ContactInfo {
  const _$ContactInfoImpl(
      {@UuidValueConverter() required this.id,
      required this.name,
      required this.avatarUrl,
      this.position,
      this.expectedSalary,
      required this.status});

  /// Unique identifier for the contact.
  @override
  @UuidValueConverter()
  final UuidValue id;

  /// Display name of the contact.
  @override
  final String name;

  /// URL of the contact's avatar image.
  @override
  final String avatarUrl;

  /// Professional position or role of the contact.
  @override
  final String? position;

  /// Expected salary range of the contact.
  @override
  final String? expectedSalary;

  /// Current status of the contact (e.g., 'Active', 'Offline').
  @override
  final String status;

  @override
  String toString() {
    return 'ContactInfo(id: $id, name: $name, avatarUrl: $avatarUrl, position: $position, expectedSalary: $expectedSalary, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.expectedSalary, expectedSalary) ||
                other.expectedSalary == expectedSalary) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, avatarUrl, position, expectedSalary, status);

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactInfoImplCopyWith<_$ContactInfoImpl> get copyWith =>
      __$$ContactInfoImplCopyWithImpl<_$ContactInfoImpl>(this, _$identity);
}

abstract class _ContactInfo implements ContactInfo {
  const factory _ContactInfo(
      {@UuidValueConverter() required final UuidValue id,
      required final String name,
      required final String avatarUrl,
      final String? position,
      final String? expectedSalary,
      required final String status}) = _$ContactInfoImpl;

  /// Unique identifier for the contact.
  @override
  @UuidValueConverter()
  UuidValue get id;

  /// Display name of the contact.
  @override
  String get name;

  /// URL of the contact's avatar image.
  @override
  String get avatarUrl;

  /// Professional position or role of the contact.
  @override
  String? get position;

  /// Expected salary range of the contact.
  @override
  String? get expectedSalary;

  /// Current status of the contact (e.g., 'Active', 'Offline').
  @override
  String get status;

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactInfoImplCopyWith<_$ContactInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

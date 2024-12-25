import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

/// Custom converter for `UuidValue` to handle JSON serialization/deserialization.
class UuidValueConverter implements JsonConverter<UuidValue, String> {
  const UuidValueConverter();

  @override
  UuidValue fromJson(String json) => UuidValue(json);

  @override
  String toJson(UuidValue uuid) => uuid.uuid;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) => ContactModel(
      id: const UuidValueConverter().fromJson(json['id'] as String),
      userName: json['userName'] as String,
      avatarUrl: json['avatarUrl'] as String,
      lastMessage: json['lastMessage'] as String,
      lastMessageCreatedTime:
          DateTime.parse(json['lastMessageCreatedTime'] as String),
      isArchived: json['isArchived'] as bool,
      isRead: json['isRead'] as bool,
    );

Map<String, dynamic> _$ContactModelToJson(ContactModel instance) =>
    <String, dynamic>{
      'id': const UuidValueConverter().toJson(instance.id),
      'userName': instance.userName,
      'avatarUrl': instance.avatarUrl,
      'lastMessage': instance.lastMessage,
      'lastMessageCreatedTime':
          instance.lastMessageCreatedTime.toIso8601String(),
      'isArchived': instance.isArchived,
      'isRead': instance.isRead,
    };

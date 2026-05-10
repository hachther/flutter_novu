// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: json['_id'] as String,
      templateId: json['_templateId'] as String,
      environmentId: json['_environmentId'] as String,
      organizationId: json['_organizationId'] as String,
      notificationId: json['_notificationId'] as String,
      subscriberId: json['_subscriberId'] as String,
      messageTemplateId: json['_messageTemplateId'] as String,
      jobId: json['_jobId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      lastSeenDate: json['lastSeenDate'] == null
          ? null
          : DateTime.parse(json['lastSeenDate'] as String),
      lastReadDate: json['lastReadDate'] == null
          ? null
          : DateTime.parse(json['lastReadDate'] as String),
      actor: json['actor'] == null
          ? null
          : Actor.fromJson(json['actor'] as Map<String, dynamic>),
      subscriber: json['subscriber'] == null
          ? null
          : SubscriberFeedResponse.fromJson(
              json['subscriber'] as Map<String, dynamic>),
      transactionId: json['transactionId'] as String,
      feedId: json['_feedId'] as String?,
      templateIdentifier: json['templateIdentifier'] as String?,
      providerId: json['providerId'] as String?,
      content: json['content'] as String,
      channel: $enumDecode(_$ChannelTypeEnumMap, json['channel']),
      read: json['read'] as bool,
      seen: json['seen'] as bool,
      subject: json['subject'] as String?,
      deleted: json['deleted'] as bool,
      deviceTokens: (json['deviceTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      cta: json['cta'] == null
          ? null
          : MessageCTA.fromJson(json['cta'] as Map<String, dynamic>),
      status: $enumDecode(_$NotificationStatusEnumMap, json['status']),
      payload: json['payload'] as Map<String, dynamic>?,
      overrides: json['overrides'] as Map<String, dynamic>?,
      archived: json['archived'] as bool?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      '_id': instance.id,
      '_templateId': instance.templateId,
      '_environmentId': instance.environmentId,
      '_organizationId': instance.organizationId,
      '_notificationId': instance.notificationId,
      '_subscriberId': instance.subscriberId,
      '_messageTemplateId': instance.messageTemplateId,
      '_feedId': instance.feedId,
      '_jobId': instance.jobId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'lastSeenDate': instance.lastSeenDate?.toIso8601String(),
      'lastReadDate': instance.lastReadDate?.toIso8601String(),
      'actor': instance.actor,
      'subscriber': instance.subscriber,
      'transactionId': instance.transactionId,
      'templateIdentifier': instance.templateIdentifier,
      'providerId': instance.providerId,
      'content': instance.content,
      'channel': _$ChannelTypeEnumMap[instance.channel]!,
      'read': instance.read,
      'seen': instance.seen,
      'archived': instance.archived,
      'subject': instance.subject,
      'deleted': instance.deleted,
      'deviceTokens': instance.deviceTokens,
      'cta': instance.cta,
      'status': _$NotificationStatusEnumMap[instance.status]!,
      'payload': instance.payload,
      'overrides': instance.overrides,
      'tags': instance.tags,
    };

const _$ChannelTypeEnumMap = {
  ChannelType.inApp: 'in_app',
  ChannelType.email: 'email',
  ChannelType.sms: 'sms',
  ChannelType.chat: 'chat',
  ChannelType.push: 'push',
};

const _$NotificationStatusEnumMap = {
  NotificationStatus.sent: 'sent',
  NotificationStatus.error: 'error',
  NotificationStatus.warning: 'warning',
};

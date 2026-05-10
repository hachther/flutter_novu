// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriber.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelCredential _$ChannelCredentialFromJson(Map<String, dynamic> json) =>
    ChannelCredential(
      webhookUrl: json['webhookUrl'] as String,
      channel: json['channel'] as String?,
      deviceTokens: (json['deviceTokens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      alertUid: json['alertUid'] as String?,
      title: json['title'] as String?,
      imageUrl: json['imageUrl'] as String?,
      state: json['state'] as String?,
      externalUrl: json['externalUrl'] as String?,
    );

Map<String, dynamic> _$ChannelCredentialToJson(ChannelCredential instance) =>
    <String, dynamic>{
      'webhookUrl': instance.webhookUrl,
      'channel': instance.channel,
      'deviceTokens': instance.deviceTokens,
      'alertUid': instance.alertUid,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'state': instance.state,
      'externalUrl': instance.externalUrl,
    };

Channel _$ChannelFromJson(Map<String, dynamic> json) => Channel(
      providerId: $enumDecode(_$ProviderIdEnumMap, json['providerId']),
      integrationIdentifier: json['_integrationIdentifier'] as String?,
      credentials: ChannelCredential.fromJson(
          json['credentials'] as Map<String, dynamic>),
      integrationId: json['integrationId'] as String,
    );

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'providerId': _$ProviderIdEnumMap[instance.providerId]!,
      '_integrationIdentifier': instance.integrationIdentifier,
      'credentials': instance.credentials,
      'integrationId': instance.integrationId,
    };

const _$ProviderIdEnumMap = {
  ProviderId.slack: 'slack',
  ProviderId.discord: 'discord',
  ProviderId.msteams: 'msteams',
  ProviderId.mattermost: 'mattermost',
  ProviderId.ryver: 'ryver',
  ProviderId.zulip: 'zulip',
  ProviderId.grafanaOnCall: 'grafana-on-call',
  ProviderId.getstream: 'getstream',
  ProviderId.rocketChat: 'rocket-chat',
  ProviderId.whatsappBusiness: 'whatsapp-business',
  ProviderId.fcm: 'fcm',
  ProviderId.apns: 'apns',
  ProviderId.expo: 'expo',
  ProviderId.oneSignal: 'one-signal',
  ProviderId.pushpad: 'pushpad',
  ProviderId.pushWebhook: 'push-webhook',
  ProviderId.pusherBeams: 'pusher-beams',
};

PreferenceTemplate _$PreferenceTemplateFromJson(Map<String, dynamic> json) =>
    PreferenceTemplate(
      id: json['_id'] as String,
      name: json['name'] as String,
      critical: json['critical'] as bool,
      triggers: (json['triggers'] as List<dynamic>)
          .map((e) => WorkflowTrigger.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$PreferenceTemplateToJson(PreferenceTemplate instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'critical': instance.critical,
      'triggers': instance.triggers,
      'tags': instance.tags,
    };

Preference _$PreferenceFromJson(Map<String, dynamic> json) => Preference(
      enabled: json['enabled'] as bool,
      channels:
          PreferenceChannel.fromJson(json['channels'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PreferenceToJson(Preference instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'channels': instance.channels,
    };

SubscriberPreference _$SubscriberPreferenceFromJson(
        Map<String, dynamic> json) =>
    SubscriberPreference(
      template:
          PreferenceTemplate.fromJson(json['template'] as Map<String, dynamic>),
      preference:
          Preference.fromJson(json['preference'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SubscriberPreferenceToJson(
        SubscriberPreference instance) =>
    <String, dynamic>{
      'template': instance.template,
      'preference': instance.preference,
    };

Subscriber _$SubscriberFromJson(Map<String, dynamic> json) => Subscriber(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      locale: json['locale'] as String?,
      timezone: json['timezone'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      subscriberId: json['subscriberId'] as String,
      isOnline: json['isOnline'] as bool?,
      lastOnlineAt: json['lastOnlineAt'] == null
          ? null
          : DateTime.parse(json['lastOnlineAt'] as String),
      organizationId: json['_organizationId'] as String,
      environmentId: json['_environmentId'] as String,
      deleted: json['_environmentId'] as bool,
      createdAt: DateTime.parse(json['_environmentId'] as String),
      updatedAt: DateTime.parse(json['_environmentId'] as String),
      v: json['__v'] as String,
    );

Map<String, dynamic> _$SubscriberToJson(Subscriber instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'locale': instance.locale,
      'timezone': instance.timezone,
      'data': instance.data,
      'subscriberId': instance.subscriberId,
    };

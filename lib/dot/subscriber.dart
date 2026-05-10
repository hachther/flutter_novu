import 'package:flutter_novu/dot/shared.dart';
import 'package:flutter_novu/dot/workflow.dart';
import 'package:flutter_novu/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscriber.g.dart';

@JsonSerializable()
class ChannelCredential {
  /// Webhook url used by chat app integrations. The webhook should be obtained from the chat app provider.
  late final String webhookUrl;

  /// Channel specification for Mattermost chat notifications
  final String? channel;

  /// Contains an array of the subscriber device tokens for a given provider. Used on Push integrations
  final List<String> deviceTokens;

  /// alert_uid for grafana on-call webhook payload
  final String? alertUid;

  /// title to be used with grafana on call webhook
  final String? title;

  /// image_url property fo grafana on call webhook
  final String? imageUrl;

  /// state property fo grafana on call webhook
  final String? state;

  /// link_to_upstream_details property fo grafana on call webhook
  final String? externalUrl;

  ChannelCredential({
    required this.webhookUrl,
    this.channel,
    this.deviceTokens = const [],
    this.alertUid,
    this.title,
    this.imageUrl,
    this.state,
    this.externalUrl
  });

  factory ChannelCredential.fromJson(Map<String, dynamic> json) => _$ChannelCredentialFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelCredentialToJson(this);
}

@JsonSerializable()
class Channel {
  /// The provider identifier for the credentials
  late final ProviderId providerId;

  /// The integration identifier
  @JsonKey(name: '_integrationIdentifier')
  final String? integrationIdentifier;

  /// Credentials payload for the specified provider
  late final ChannelCredential credentials;

  /// Id of the integration that is used for this channel
  late final String integrationId;

  Channel({
    required this.providerId,
    this.integrationIdentifier,
    required this.credentials,
    required this.integrationId,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => _$ChannelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}

@JsonSerializable()
class PreferenceTemplate {
  /// Unique identifier of the workflow
  @JsonKey(name: '_id')
  late final String id;

  /// Name of the workflow
  late final String name;

  /// Critical templates will always be delivered to the end user and should be hidden from the subscriber preferences screen
  late final bool critical;

  /// Triggers are the events that will trigger the workflow.
  late final List<WorkflowTrigger> triggers;

  final List<String> tags;

  PreferenceTemplate({
    required this.id,
    required this.name,
    required this.critical,
    required this.triggers,
    this.tags = const [],
  });

  factory PreferenceTemplate.fromJson(Map<String, dynamic> json) => _$PreferenceTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$PreferenceTemplateToJson(this);
}

@JsonSerializable()
class Preference {
  /// Sets if the workflow is fully enabled for all channels or not for the subscriber.
  late final bool enabled;

  /// Subscriber preferences for the different channels regarding this workflow
  late final PreferenceChannel channels;

  Preference({
    required this.enabled,
    required this.channels,
  });

  factory Preference.fromJson(Map<String, dynamic> json) => _$PreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$PreferenceToJson(this);
}

@JsonSerializable()
class SubscriberPreference {
  /// The workflow information and if it is critical or not
  late final PreferenceTemplate template;

  /// The preferences of the subscriber regarding the related workflow
  late final Preference preference;

  SubscriberPreference({
    required this.template,
    required this.preference,
  });

  factory SubscriberPreference.fromJson(Map<String, dynamic> json) => _$SubscriberPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriberPreferenceToJson(this);
}

@JsonSerializable()
class Subscriber {
  /// The internal id novu generated for your subscriber, this is not the subscriberId matching your query.
  @JsonKey(name: '_id')
  final String? id;

  final String? firstName;

  final String? lastName;

  final String? email;

  final String? phone;

  final String? avatar;

  final String? locale;

  final String? timezone;

  final Map<String, dynamic>? data;

  /// The internal identifier you used to create this subscriber, usually correlates to the id the user in your systems
  late final String subscriberId;

  /// Channels settings for subscriber
  @JsonKey(includeToJson: false)
  final List<Channel> channels = [];

  /// Topics that subscriber belongs to
  @JsonKey(includeToJson: false)
  final List<String> topics = [];

  @JsonKey(includeToJson: false)
  final bool? isOnline;

  @JsonKey(includeToJson: false)
  final DateTime? lastOnlineAt;

  @JsonKey(name: '_organizationId', includeToJson: false)
  final String? organizationId;

  @JsonKey(name: '_environmentId', includeToJson: false)
  final String? environmentId;

  @JsonKey(name: '_environmentId', includeToJson: false)
  final bool? deleted;

  @JsonKey(name: '_environmentId', includeToJson: false)
  final DateTime? createdAt;

  @JsonKey(name: '_environmentId', includeToJson: false)
  final DateTime? updatedAt;

  @JsonKey(name: '__v', includeToJson: false)
  final String? v;

  Subscriber({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.avatar,
    this.locale,
    this.timezone,
    this.data,
    required this.subscriberId,
    this.isOnline,
    this.lastOnlineAt,
    this.organizationId,
    this.environmentId,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Subscriber.fromJson(Map<String, dynamic> json) => _$SubscriberFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriberToJson(this);
}
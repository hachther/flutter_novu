import 'package:flutter/material.dart';
import 'package:flutter_novu/dot.dart' as Dot;
import 'package:flutter_novu/enums.dart';
import 'package:flutter_novu/inbox.dart';
import 'package:flutter_novu/types.dart';
import 'package:flutter_novu/widgets/card.dart';

import '../generated/app_localizations.dart';
import 'list_item.dart';

class NotificationPreference extends StatefulWidget {
  final Dot.PreferencesResponse preference;
  final HeadlessService headlessService;
  // final dynamic headlessService;

  const NotificationPreference({
    super.key,
    required this.preference,
    required this.headlessService,
  });

  @override
  _NotificationPreferenceState createState() => _NotificationPreferenceState();
}

class _NotificationPreferenceState extends State<NotificationPreference> {
  bool collapsed = true;
  late Map<String, bool> values;

  @override
  void initState() {
    super.initState();
    var channel = widget.preference.channels;
    values = {
      if (channel.email != null) 'email': channel.email!,
      if (channel.sms != null) 'sms': channel.sms!,
      if (channel.inApp != null) 'in_app': channel.inApp!,
      if (channel.chat != null) 'chat': channel.chat!,
      if (channel.push != null) 'push': channel.push!,
    };
  }

  void onChanged(String channel, bool value) async {
    setState(() {
      values[channel] = value;
    });
    var workflow = widget.preference.workflow;
    if (workflow != null) {
      await widget.headlessService.updateWorkflowPreferences(workflow.id, {channel: value});
    } else {
      await widget.headlessService.updateGlobalPreferences({channel: value});
    }
    // context.read<AppConfigsCubit>().updateNotificationsPreference(response);
  }

  @override
  Widget build(BuildContext context) {
    var workflow = widget.preference.workflow;
    return ExtendedCard(
      title: workflow?.name ?? SNovu.of(context)?.globalPreferences ?? 'Global Preferences',
      titleStyle: Theme.of(context).textTheme.titleMedium,
      subtitle: values.keys.where((c) => values[c]!).map((c) => SNovu.of(context)?.novuChannel(c) ?? c).join(', '),
      subtitleStyle: Theme.of(context).textTheme.titleSmall,
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      padding: 10,
      actions: [
        NovuActionOption(
          icon: collapsed ? Icons.expand_more : Icons.expand_less,
          onPress: () {
            setState(() {
              collapsed = !collapsed;
            });
          },
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ],
      child: Column(
        children: [
          if (!collapsed)
            ListView(
              shrinkWrap: true,
              children: values.keys.map((channel) {
                return ListItem(
                  title: SNovu.of(context)?.novuChannel(channel) ?? channel,
                  type: ListItemType.switching,
                  padding: const EdgeInsets.all(0),
                  onChange: (value) => onChanged(channel, value),
                  value: values[channel],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
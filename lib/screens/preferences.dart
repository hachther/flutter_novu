import 'package:flutter/material.dart';
import 'package:flutter_novu/dot/inbox_notification.dart';
import 'package:flutter_novu/generated/app_localizations.dart';
import 'package:flutter_novu/inbox.dart';
import 'package:flutter_novu/widgets/notification_preferences.dart';

class NotificationsPreferencesScreen extends StatefulWidget {
  final HeadlessService headlessService;
  
  const NotificationsPreferencesScreen({super.key, required this.headlessService});

  @override
  State<NotificationsPreferencesScreen> createState() =>
      _NotificationsPreferencesScreenState();
}

class _NotificationsPreferencesScreenState
    extends State<NotificationsPreferencesScreen> {
  List<PreferencesResponse> _preferences = [];

  @override
  void initState() {
    super.initState();

    widget.headlessService.fetchPreferences().then((var preferences) {
      setState(() {
        _preferences = preferences;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          SNovu.of(context)?.notificationsPreferences ?? 'Notifications Preferences',
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: NotificationPreferences(
        preferences: _preferences,
        headlessService: widget.headlessService,
        onRefresh: () async {
          // widget.headlessService.fetchPreferences().then((var preferences) {
          //   context.read<AppConfigsCubit>().setNotificationsPreferences(preferences);
          // });
        },
      ),
    );
  }
}

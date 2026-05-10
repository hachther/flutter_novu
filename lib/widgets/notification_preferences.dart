import 'package:flutter/material.dart';
import 'package:flutter_novu/dot/inbox_notification.dart' as dot;
import 'package:flutter_novu/generated/app_localizations.dart';
import 'package:flutter_novu/inbox.dart';
import 'package:flutter_novu/widgets/bell_icon_painter.dart';
import 'package:flutter_novu/widgets/notification_preference.dart';

class NotificationPreferences extends StatelessWidget {
  final VoidCallback? onRefresh;
  final List<dot.PreferencesResponse> preferences;
  final HeadlessService headlessService;

  const NotificationPreferences({super.key, this.onRefresh, required this.preferences, required this.headlessService});

  @override
  Widget build(BuildContext context) {
    if (preferences.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom bell icon with animated waves
              CustomPaint(
                size: const Size(120, 120),
                painter: BellIconPainter(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 32),
              // Message
              Text(
                SNovu.of(context)?.noNotificationSettings ?? 'No notification settings found',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                SNovu.of(context)?.noNotificationSettingsMessage ?? 'It looks like you haven\'t set up any notification preferences yet. Start by creating your first preference to receive notifications tailored to your needs.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              if (onRefresh != null)
                ElevatedButton.icon(
                  onPressed: onRefresh,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(SNovu.of(context)?.refresh ?? 'Refresh'),
                ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: preferences.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            if (index == 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Image.asset('assets/images/icons/notifications.png', width: 100, package: 'flutter_novu',),
                    const SizedBox(height: 20,),
                    Text(
                      SNovu.of(context)?.notifications ?? 'Notifications',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20,),
                    Text(
                      SNovu.of(context)?.notificationsMessage ?? 'By setting up your notifications you will efficiently use this app',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            NotificationPreference(preference: preferences[index], headlessService: headlessService)
          ],
        );
      },
    );
  }
}

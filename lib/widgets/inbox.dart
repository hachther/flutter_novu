import 'package:flutter/material.dart';
import 'package:flutter_novu/screens/notifications.dart';
import 'package:flutter_novu/types.dart';

import '../dot/context_value.dart';
import '../dot/subscriber.dart';
import '../inbox.dart';

class Inbox extends StatefulWidget {
  final String backendUrl;
  final String socketUrl;
  final String applicationIdentifier;
  final String? subscriberId;
  final Widget? icon;
  final List<InboxTab> tabs;
  final Map<String, ContextValue>? context;
  final Subscriber? subscriber;

  const Inbox({super.key,
    this.backendUrl = 'https://eu.api.novu.co',
    this.socketUrl = 'https://eu.ws.novu.co',
    required this.applicationIdentifier,
    this.subscriberId,
    this.icon,
    this.tabs = const [],
    this.context,
    this.subscriber,
  }): assert(subscriberId != null || subscriber != null, 'Subscriber or subscriberId is required!');

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  late final HeadlessService _headless;
  int unreadCount = 0;
  int unseenCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _headless = HeadlessService(
      backendUrl: widget.backendUrl,
      socketUrl: widget.socketUrl,
      applicationIdentifier: widget.applicationIdentifier,
      subscriberId: widget.subscriberId,
      subscriber: widget.subscriber,
      onUnreadChanged: (count) {
        setState(() {
          unreadCount = count;
        });
      },
      onUnseenChanged: (count) {
        setState(() {
          unseenCount = count;
        });
      },
      // onReceived: (notification) {
      //   // Handle received notification
      // },
      tabs: widget.tabs,
      context: widget.context,
    );
  }

  @override
  Widget build(BuildContext context) {
    var icon =  IconButton(
      icon: widget.icon ?? const Icon(Icons.notifications),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute<void>(
          builder: (context) => NotificationsScreen(
            headlessService: _headless,
          ),
        ));
      },
    );
    if (unreadCount > 0) {
      return Badge(
        label: Text(unreadCount.toString()),
        offset: Offset(-4, 2),
        child: icon,
      );
    }

    return icon;
  }
}

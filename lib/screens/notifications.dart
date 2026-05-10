import 'package:flutter/material.dart';
import 'package:flutter_novu/dot/inbox_notification.dart';
import 'package:flutter_novu/enums.dart';
import 'package:flutter_novu/generated/app_localizations.dart';
import 'package:flutter_novu/inbox.dart';
import 'package:flutter_novu/screens/preferences.dart';
import 'package:flutter_novu/widgets/notification_tile.dart';
import 'package:shimmer/shimmer.dart';

enum PageFilter {
  all,
  archived,
  unread,
}

enum PageAction {
  markAllAsRead,
  archiveAll,
  archiveRead,
}

class NotificationsScreen extends StatefulWidget {
  final HeadlessService headlessService;
  final Widget Function(InboxNotification notification)? renderNotification;

  const NotificationsScreen({
    super.key,
    required this.headlessService,
    this.renderNotification
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with TickerProviderStateMixin {
  PageFilter view = PageFilter.all; // 'all', 'archived', 'unread'
  final ScrollController _scrollController = ScrollController();
  List<InboxNotification> _notifications = [];
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 0;
  final int _pageSize = 20;
  late TabController _tabController;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadNotifications();
    _tabController = TabController(
      length: widget.headlessService.tabs.length,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMoreData) {
        _loadNotifications();
      }
    }
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      _tab = _tabController.index;
    });
    _refreshNotifications();
  }

  Future<void> _loadNotifications({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (refresh) {
        _currentPage = 0;
        _notifications.clear();
        _hasMoreData = true;
      }

      var response = await widget.headlessService.getNotifications(
        archived: view == PageFilter.archived,
        read: [PageFilter.all, PageFilter.archived].contains(view) ? null : false,
        page: _currentPage,
        limit: _pageSize,
        tags: widget.headlessService.tabs.isNotEmpty ? widget.headlessService.tabs[_tab].filter?.tags ?? [] : [],
      );

      setState(() {
        if (refresh) {
          _notifications = response.data;
        } else {
          _notifications.addAll(response.data);
        }
        _hasMoreData = response.hasMore;
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshNotifications() async {
    await _loadNotifications(refresh: true);
  }

  Widget _renderNotification(int index, InboxNotification notification) {
    return Column(
      children: [
        if (index > 0)
          const Divider(height: 0.2, indent: 10, endIndent: 10,),
        NotificationTile(
          notification: notification,
          onMarkAsArchived: (notificationId) async {
            await widget.headlessService.markNotificationAs(
                notificationId, MarkNotificationAs.archive);
            setState(() {
              _notifications = _notifications.where((n) => n.id != notificationId).toList();
            });
          },
          onMarkAsUnArchived: (notificationId) async {
            await widget.headlessService.markNotificationAs(
                notificationId, MarkNotificationAs.unarchive);
            setState(() {
              _notifications = _notifications.where((n) => n.id != notificationId).toList();
            });
          },
          onMarkAsRead: (notificationId) async {
            await widget.headlessService.markNotificationAs(
                notificationId, MarkNotificationAs.read);
            _refreshNotifications();
          },
          onTap: (notification) async {
            await widget.headlessService.markNotificationAs(
                notification.id, MarkNotificationAs.read);
            _refreshNotifications();
          },

          renderNotification: widget.renderNotification,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var pageTitle = SNovu.of(context)?.inbox;
    switch (view) {
      case PageFilter.all:
        pageTitle = SNovu.of(context)?.inbox;
        break;
      case PageFilter.unread:
        pageTitle = SNovu.of(context)?.unreadOnly;
        break;
      case PageFilter.archived:
        pageTitle = SNovu.of(context)?.archived;
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: PopupMenuButton<PageFilter>(
          onSelected: (value) {
            setState(() {
              view = value;
              _refreshNotifications();
            });
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: PageFilter.all,
              child: Text(SNovu.of(context)?.unreadAndRead ?? 'Unread And Read'),
            ),
            PopupMenuItem(
              value: PageFilter.unread,
              child: Text(SNovu.of(context)?.unreadOnly ?? 'Unread Only'),
            ),
            PopupMenuItem(
              value: PageFilter.archived,
              child: Text(SNovu.of(context)?.archived ?? 'Archived'),
            ),
          ],
          child: Text.rich(TextSpan(
            children: [
              TextSpan(text: pageTitle),
              const WidgetSpan(child: Icon(Icons.keyboard_arrow_down))
              // if (view != 'all') TextSpan(text: ' (${view.capitalize()})', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          )),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (context) => NotificationsPreferencesScreen(
                  headlessService: widget.headlessService,
                ),
              ));
            },
            child: const Icon(Icons.settings),
          ),
          PopupMenuButton<MarkAllNotificationAs>(
            onSelected: (value) {
              widget.headlessService.markAllNotificationAs(MarkAllNotificationAs.read);
              _refreshNotifications();
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: MarkAllNotificationAs.read,
                child: Text(SNovu.of(context)?.markAllAsRead ?? 'Mark All As Read'),
              ),
              PopupMenuItem(
                value: MarkAllNotificationAs.archive,
                child: Text(SNovu.of(context)?.archiveAll ?? 'Archive All'),
              ),
              PopupMenuItem(
                value: MarkAllNotificationAs.readArchive,
                child: Text(SNovu.of(context)?.archiveRead ?? 'Archive Read'),
              ),
            ],
          ),
        ],
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: Column(
          children: [
            if (widget.headlessService.tabs.isNotEmpty == true) _buildCustomTabs(),
            Expanded(
              child: _buildBodyContent(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_isLoading && _notifications.isEmpty) {
      return _buildShimmerList();
    }

    if (_notifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _notifications.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _notifications.length) {
          return _isLoading ? _buildShimmerItem() : const SizedBox.shrink();
        }

        final notification = _notifications[index];
        return _renderNotification(index, notification);
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => _buildShimmerItem(),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24,
        ),
        title: Container(
          height: 16.0,
          width: double.infinity,
          color: Colors.white,
        ),
        subtitle: Container(
          height: 12.0,
          width: double.infinity,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;

    switch (view) {
      case PageFilter.unread:
        message = SNovu.of(context)?.noUnreadNotifications ?? 'No Unread Notifications';
        icon = Icons.mark_email_read;
        break;
      case PageFilter.archived:
        message = SNovu.of(context)?.noArchivedNotifications ?? 'No Archived Notifications';
        icon = Icons.archive;
        break;
      default:
        message = SNovu.of(context)?.noNotifications ?? 'No Notifications';
        icon = Icons.notifications_none;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabs() {
    return SizedBox(
      height: 48,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        onTap: (index) {
          // widget.onTabChanged?.call(widget.tabs![index].id);
        },
        tabs: widget.headlessService.tabs.map((tab) => Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // if (tab.icon != null) ...[
              //   Icon(tab.icon),
              //   const SizedBox(width: 4),
              // ],
              Text(tab.label),
              // if (tab.showCount) ...[
              //   const SizedBox(width: 4),
              //   _buildCountBadge(_getTabCount(tab)),
              // ],
            ],
          ),
        )).toList(),
      ),
    );
  }
}
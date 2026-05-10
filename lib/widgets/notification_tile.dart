import 'package:flutter/material.dart';
import 'package:flutter_novu/generated/app_localizations.dart';
import 'package:flutter_novu/utils.dart';
import 'package:flutter_novu/widgets/content.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../dot/inbox_notification.dart';

class NotificationTile extends StatelessWidget {
  final InboxNotification notification;
  final Function(String notificationId)? onMarkAsRead;
  final Function(String notificationId)? onMarkAsArchived;
  final Function(String notificationId)? onMarkAsUnArchived;
  final Function(InboxNotification notification)? onTap;

  final Widget Function(InboxNotification notification)? renderNotification;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onMarkAsRead,
    this.onMarkAsArchived,
    this.onMarkAsUnArchived,
    this.onTap,
    this.renderNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      background: _buildDismissibleBackground(
        context,
        color: Colors.green,
        icon: Icons.mark_email_read,
        alignment: Alignment.centerLeft,
        label: SNovu.of(context)?.markAsRead ?? 'Mark as Read',
      ),
      secondaryBackground: _buildDismissibleBackground(
        context,
        color: Colors.orange,
        icon: Icons.archive,
        alignment: Alignment.centerRight,
        label: SNovu.of(context)?.archive ?? 'Archive',
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onMarkAsRead?.call(notification.id);
        } else if (direction == DismissDirection.endToStart) {
          onMarkAsArchived?.call(notification.id);
        }
      },
      child: InkWell(
        onTap: () {
          onTap?.call(notification);
          if (notification.redirect != null &&
              notification.redirect!.url != null) {
            launchURL(notification.redirect!.url!);
          }
        },
        child: renderNotification?.call(notification) ?? Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: notification.isRead
              ? Theme.of(context).canvasColor
              : Theme.of(context).primaryColor.withOpacity(0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReadIndicator(),
                  const SizedBox(width: 12),
                  if (notification.avatar != null &&
                      notification.avatar!.isNotEmpty) ...[
                    _buildAvatar(),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 4),
                        _buildContent(),
                        const SizedBox(height: 8),
                        _buildFooter(context),
                      ],
                    ),
                  ),
                  _buildActionsButton(context),
                ],
              ),
              if (notification.primaryAction != null ||
                  notification.secondaryAction != null)
                _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDismissibleBackground(
    BuildContext context, {
    required Color color,
    required IconData icon,
    required Alignment alignment,
    required String label,
  }) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    var avatar = notification.avatar;
    if (avatar != null && avatar.isNotEmpty) {
      if (avatar.endsWith('svg')) {
        return SvgPicture.network(
          avatar,
          width: 40,
          height: 40,
          placeholderBuilder: (context) => const CircleAvatar(radius: 20),
        );
      } else {
        return CircleAvatar(
          backgroundImage: NetworkImage(avatar),
          radius: 20,
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      notification.subject ?? '',
      style: TextStyle(
        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        fontSize: 16,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildContent() {
    return Content(text: notification.body);
  }

  Widget _buildFooter(BuildContext context) {
    return Text(
      _formatDate(context, notification.createdAt),
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 12,
      ),
    );
  }

  Widget _buildReadIndicator() {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.transparent : Colors.blue,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildActionsButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
      onSelected: (value) {
        switch (value) {
          case 'read':
            onMarkAsRead?.call(notification.id);
            break;
          case 'archive':
            onMarkAsArchived?.call(notification.id);
            break;
          case 'unarchive':
            onMarkAsUnArchived?.call(notification.id);
            break;
        }
      },
      itemBuilder: (context) => [
        if (!notification.isRead)
          PopupMenuItem(
            value: 'read',
            child: ListTile(
              leading: const Icon(Icons.mark_email_read),
              title: Text(SNovu.of(context)?.markAsRead ?? 'Mark as Read'),
            ),
          ),
        if (notification.isArchived != true)
          PopupMenuItem(
            value: 'archive',
            child: ListTile(
              leading: const Icon(Icons.archive),
              title: Text(SNovu.of(context)?.archive ?? 'Archive'),
            ),
          ),
        if (notification.isArchived == true)
          PopupMenuItem(
            value: 'unarchive',
            child: ListTile(
              leading: const Icon(Icons.unarchive),
              title: Text(SNovu.of(context)?.unarchive ?? 'Unarchive'),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (notification.secondaryAction != null)
            TextButton(
              onPressed: () {
                if (notification.secondaryAction!.redirect != null &&
                    notification.secondaryAction!.redirect!.url != null) {
                  launchURL(notification.secondaryAction!.redirect!.url!);
                }
              },
              child: Text(notification.secondaryAction!.label),
            ),
          const SizedBox(width: 8),
          if (notification.primaryAction != null)
            ElevatedButton(
              onPressed: () {
                if (notification.primaryAction!.redirect != null &&
                    notification.primaryAction!.redirect!.url != null) {
                  launchURL(notification.primaryAction!.redirect!.url!);
                }
              },
              child: Text(notification.primaryAction!.label),
            ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return SNovu.of(context)?.justNow ?? 'Just now';
    } else if (difference.inMinutes < 60) {
      return SNovu.of(context)?.dateAgo('${difference.inMinutes}m') ?? '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return SNovu.of(context)?.dateAgo('${difference.inHours}h') ?? '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return SNovu.of(context)?.dateAgo('${difference.inDays}d') ?? '${difference.inDays}d ago';
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }
}
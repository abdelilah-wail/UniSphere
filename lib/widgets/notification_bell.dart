import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/notification_model.dart';
import 'notification_panel.dart';

class NotificationBell extends StatefulWidget {
  final List<NotificationModel> notifications;
  final ValueChanged<NotificationModel>? onNotificationTap;
  final VoidCallback? onMarkAllRead;
  final VoidCallback? onViewAll;

  const NotificationBell({
    super.key,
    required this.notifications,
    this.onNotificationTap,
    this.onMarkAllRead,
    this.onViewAll,
  });

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  final GlobalKey _bellKey = GlobalKey();

  int get _unreadCount =>
      widget.notifications.where((n) => !n.isRead).length;

  void _showPanel() {
    final RenderBox renderBox =
        _bellKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size bellSize = renderBox.size;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss notifications',
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedAnim = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutCubic,
        );
        final screenWidth = MediaQuery.of(context).size.width;
        final panelWidth = screenWidth > 500 ? 380.0 : screenWidth - 32;
        final rightOffset = screenWidth - offset.dx - bellSize.width;

        return Stack(
          children: [
            Positioned(
              top: offset.dy + bellSize.height + 8,
              right: rightOffset < 16 ? 16 : rightOffset,
              width: panelWidth,
              child: FadeTransition(
                opacity: curvedAnim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.1),
                    end: Offset.zero,
                  ).animate(curvedAnim),
                  child: NotificationPanel(
                    notifications: widget.notifications,
                    onNotificationTap: (notification) {
                      Navigator.of(context).pop();
                      widget.onNotificationTap?.call(notification);
                    },
                    onMarkAllRead: () {
                      widget.onMarkAllRead?.call();
                      Navigator.of(context).pop();
                    },
                    onViewAll: () {
                      Navigator.of(context).pop();
                      widget.onViewAll?.call();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _bellKey,
      onTap: _showPanel,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withOpacity(0.05),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 24,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.6),
            ),
            if (_unreadCount > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _unreadCount > 9 ? '9+' : '$_unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

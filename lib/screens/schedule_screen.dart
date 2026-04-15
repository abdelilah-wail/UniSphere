import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../helpers/nav_helper.dart';
import '../models/schedule_model.dart';
import '../services/schedule_service.dart';
import '../services/api_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/schedule_detail_sheet.dart';
import '../models/notification_model.dart';
import '../helpers/notification_helper.dart';
import '../widgets/notification_bell.dart';

class ScheduleScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const ScheduleScreen({super.key, this.onToggleTheme});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<String> _fullDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  int _selectedDay = 0;

  List<ScheduleModel> _scheduleItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    // Set initial day to today
    final today = DateTime.now().weekday;
    if (today >= 1 && today <= 6) {
      _selectedDay = today - 1;
    }

    _fetchSchedule();
    NotificationHelper.ensureLoaded().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _fetchSchedule() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await ScheduleService.getSchedule(
        day: _fullDays[_selectedDay],
      );
      if (mounted) {
        setState(() {
          _scheduleItems = data
              .map((json) => ScheduleModel.fromJson(json))
              .toList();
          _isLoading = false;
        });
        _fadeController.reset();
        _fadeController.forward();
      }
    } on ApiException catch (e) {
      if (mounted)
        setState(() {
          _error = e.message;
          _isLoading = false;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _error = 'Connection error: $e';
          _isLoading = false;
        });
    }
  }

  void _onDaySelected(int index) {
    if (index == _selectedDay) return;
    setState(() => _selectedDay = index);
    _fetchSchedule();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── App Bar ─────────────────────────────
            // ─── Header with Theme & Notification ─────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left: Title
                  Expanded(
                    child: Text(
                      'Schedule',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  // Right: Theme + Bell side by side
                  GestureDetector(
                    onTap: widget.onToggleTheme,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.05),
                      ),
                      child: Icon(
                        isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        size: 22,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  NotificationBell(
                    notifications: NotificationHelper.notifications,
                    onNotificationTap: (notif) async {
                      await NotificationHelper.markAsRead(notif);
                      if (mounted) setState(() {});
                    },
                    onMarkAllRead: () async {
                      await NotificationHelper.markAllAsRead();
                      if (mounted) setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
              child: Text(
                _fullDays[_selectedDay],
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.45),
                ),
              ),
            ),

            // ─── Day Tabs ────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(_days.length, (index) {
                  final isSelected = index == _selectedDay;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _onDaySelected(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(
                          right: index < _days.length - 1 ? 8 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primary
                              : (isDark
                                    ? const Color(0xFF1E1E1E)
                                    : const Color(0xFFF0EBF0)),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            _days[index],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // ─── Schedule List ───────────────────────
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _error!,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _fetchSchedule,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _scheduleItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event_busy_rounded,
                            size: 48,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.15),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No classes on ${_fullDays[_selectedDay]}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    )
                  : FadeTransition(
                      opacity: _fadeAnim,
                      child: RefreshIndicator(
                        onRefresh: _fetchSchedule,
                        color: AppTheme.primary,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          itemCount: _scheduleItems.length,
                          itemBuilder: (context, index) {
                            return _ScheduleCard(
                              item: _scheduleItems[index],
                              delay: index,
                              onTap: () => showScheduleDetail(
                                context,
                                _scheduleItems[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          handleNavTap(
            context: context,
            currentIndex: 2,
            tappedIndex: index,
            onToggleTheme: widget.onToggleTheme,
          );
        },
      ),
    );
  }
}

// ── Schedule Card ───────────────────────────────────
class _ScheduleCard extends StatefulWidget {
  final ScheduleModel item;
  final int delay;
  final VoidCallback? onTap;
  const _ScheduleCard({required this.item, this.delay = 0, this.onTap});

  @override
  State<_ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<_ScheduleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: 80 * widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time column
                SizedBox(
                  width: 52,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.startTime,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.endTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: item.cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: item.cardColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.courseName,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: item.textColor,
                            height: 1.2,
                          ),
                        ),
                        if (item.lectureInfo.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.lectureInfo,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: item.textColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 15,
                              color: item.textColor.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.room,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: item.textColor.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.person_outline_rounded,
                              size: 15,
                              color: item.textColor.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.teacher,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: item.textColor.withOpacity(0.7),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

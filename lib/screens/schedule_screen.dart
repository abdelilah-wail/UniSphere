import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../helpers/nav_helper.dart';
import '../models/schedule_model.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/notification_model.dart';
import '../helpers/notification_data.dart';
import '../widgets/notification_bell.dart';
import '../widgets/schedule_detail_sheet.dart';

// Add state variable in _HomeScreenState:
final List<NotificationModel> _notifications = getSampleNotifications();

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

  DateTime _selectedDate = DateTime(2024, 7, 6);
  late List<DateTime> _weekDays;

  final List<ScheduleModel> _scheduleItems = [
    ScheduleModel(
      courseName: 'Computer Science',
      lectureInfo: 'Lecture 2: Data management',
      startTime: '11:35',
      endTime: '13:05',
      room: 'Room 2 - 124',
      teacher: 'Mam Laiba Khalid',
      cardColor: const Color(0xFFB8F5B1),
    ),
    ScheduleModel(
      courseName: 'Digital Marketing',
      lectureInfo: 'Lecture 3: Shopify Creation',
      startTime: '13:15',
      endTime: '14:45',
      room: 'Room 3A - G4',
      teacher: 'Mam Hira',
      cardColor: const Color(0xFFE8F549),
      textColor: Color(0xFFC62828),
    ),
    ScheduleModel(
      courseName: 'Digital Marketing',
      lectureInfo: 'Lecture 3: Shopify Creation',
      startTime: '15:10',
      endTime: '16:40',
      room: 'Room 7B - B1',
      teacher: 'Mam Laiba Khalid',
      cardColor: const Color(0xFFBCC8D4),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
    _generateWeekDays();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _generateWeekDays() {
    final weekday = _selectedDate.weekday;
    final saturday = _selectedDate.subtract(Duration(days: (weekday + 1) % 7));
    _weekDays = List.generate(7, (i) => saturday.add(Duration(days: i)));
  }

  String _getDayAbbr(DateTime date) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days[date.weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      'Schedule',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
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
                          Theme.of(context).brightness == Brightness.dark
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
                      notifications: _notifications,
                      onNotificationTap: (notif) {
                        setState(() => notif.isRead = true);
                      },
                      onMarkAllRead: () {
                        setState(() {
                          for (var n in _notifications) {
                            n.isRead = true;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Date Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _selectedDate.day.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getDayName(_selectedDate.weekday),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            '${_getMonthName(_selectedDate.month)},${_selectedDate.year}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Week Day Selector
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFFF5F0F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _weekDays.map((date) {
                      final isSelected =
                          date.day == _selectedDate.day &&
                          date.month == _selectedDate.month;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDate = date),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 42,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _getDayAbbr(date),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.8)
                                      : Theme.of(context).colorScheme.onSurface
                                            .withOpacity(0.4),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                date.day.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Column Headers
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.45),
                        ),
                      ),
                    ),
                    Text(
                      'Courses',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.45),
                      ),
                    ),
                  ],
                ),
              ),

              // Schedule List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  itemCount: _scheduleItems.length,
                  itemBuilder: (context, index) => _ScheduleCard(
                    item: _scheduleItems[index],
                    delay: index,
                    onTap: () => showScheduleDetail(context, _scheduleItems[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ✅ Bottom Nav using handleNavTap
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
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: 120 * widget.delay), () {
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
                  width: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.item.startTime,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                                color: Theme.of(context).colorScheme.onSurface)),
                        const SizedBox(height: 2),
                        Text(widget.item.endTime,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4))),
                      ],
                    ),
                  ),
                ),
                // Course card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: widget.item.cardColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.item.courseName,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                                          color: widget.item.textColor, height: 1.2)),
                                  const SizedBox(height: 4),
                                  Text(widget.item.lectureInfo,
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,
                                          color: widget.item.textColor.withOpacity(0.7))),
                                ],
                              ),
                            ),
                            Icon(Icons.more_vert_rounded, size: 22,
                                color: widget.item.textColor.withOpacity(0.5)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Icon(Icons.location_on_outlined, size: 16,
                                      color: widget.item.textColor.withOpacity(0.6)),
                                  const SizedBox(width: 4),
                                  Text(widget.item.room,
                                      style: TextStyle(fontSize: 13,
                                          color: widget.item.textColor.withOpacity(0.7))),
                                ]),
                                const SizedBox(height: 4),
                                Row(children: [
                                  Icon(Icons.person_outline_rounded, size: 16,
                                      color: widget.item.textColor.withOpacity(0.6)),
                                  const SizedBox(width: 4),
                                  Text(widget.item.teacher,
                                      style: TextStyle(fontSize: 13,
                                          color: widget.item.textColor.withOpacity(0.7))),
                                ]),
                              ],
                            ),
                          ),
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(shape: BoxShape.circle,
                                color: widget.item.textColor.withOpacity(0.08)),
                            child: Icon(Icons.notifications_none_rounded, size: 20,
                                color: widget.item.textColor.withOpacity(0.6)),
                          ),
                        ]),
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

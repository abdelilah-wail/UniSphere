import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../helpers/nav_helper.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/notification_model.dart';
import '../helpers/notification_data.dart';
import '../widgets/notification_bell.dart';
import 'course_detail_screen.dart';

// Add state variable in _HomeScreenState:
final List<NotificationModel> _notifications = getSampleNotifications();

class CoursesScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;

  const CoursesScreen({super.key, this.onToggleTheme});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  final List<String> _allCourses = const [
    'Digital Marketing',
    'Design Learning',
    'Artificial Intelligence',
    'Software Management',
    'Digital Logical Thoughts',
    'Web 3.0',
    'Calculas',
    'Physics',
    'Mathematics',
  ];

  List<String> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _filteredCourses = List.from(_allCourses);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredCourses = query.isEmpty
          ? List.from(_allCourses)
          : _allCourses.where((c) => c.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      'Courses',
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

              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.35),
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 22,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.35),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ),

              // Courses List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                  itemCount: _filteredCourses.length,
                  itemBuilder: (context, index) => _CourseListItem(
                    name: _filteredCourses[index],
                    delay: index,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseDetailScreen(
                            courseName: _filteredCourses[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ✅ Bottom Nav using handleNavTap
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          handleNavTap(
            context: context,
            currentIndex: 1,
            tappedIndex: index,
            onToggleTheme: widget.onToggleTheme,
          );
        },
      ),
    );
  }
}

class _CourseListItem extends StatefulWidget {
  final String name;
  final VoidCallback? onTap;
  final int delay;

  const _CourseListItem({required this.name, this.onTap, this.delay = 0});

  @override
  State<_CourseListItem> createState() => _CourseListItemState();
}

class _CourseListItemState extends State<_CourseListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  bool _isPressed = false;

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
    Future.delayed(Duration(milliseconds: 60 * widget.delay), () {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onTap?.call();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E1E1E).withOpacity(_isPressed ? 0.8 : 1)
                  : Colors.white.withOpacity(_isPressed ? 0.85 : 1),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    isDark
                        ? (_isPressed ? 0.15 : 0.2)
                        : (_isPressed ? 0.02 : 0.05),
                  ),
                  blurRadius: _isPressed ? 6 : 12,
                  offset: Offset(0, _isPressed ? 1 : 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../helpers/nav_helper.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';
import '../services/api_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/notification_model.dart';
import '../helpers/notification_helper.dart';
import '../widgets/notification_bell.dart';
import 'course_detail_screen.dart';

class CoursesScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const CoursesScreen({super.key, this.onToggleTheme});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  List<CourseModel> _courses = [];
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
    _fetchCourses();
    NotificationHelper.ensureLoaded().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await CourseService.getCourses();
      if (mounted) {
        setState(() {
          _courses = data.map((json) => CourseModel.fromJson(json)).toList();
          _isLoading = false;
        });
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
                      'Courses',
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
                '${_courses.length} courses available',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.45),
                ),
              ),
            ),

            // ─── Course List ────────────────────────
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
                            onPressed: _fetchCourses,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _courses.isEmpty
                  ? Center(
                      child: Text(
                        'No courses yet',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    )
                  : FadeTransition(
                      opacity: _fadeAnim,
                      child: RefreshIndicator(
                        onRefresh: _fetchCourses,
                        color: AppTheme.primary,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          itemCount: _courses.length,
                          itemBuilder: (context, index) {
                            return _CourseCard(
                              course: _courses[index],
                              delay: index,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseDetailScreen(
                                      courseId: _courses[index].id,
                                    ),
                                  ),
                                );
                              },
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

// ── Course Card ──────────────────────────────────────
class _CourseCard extends StatefulWidget {
  final CourseModel course;
  final int delay;
  final VoidCallback? onTap;
  const _CourseCard({required this.course, this.delay = 0, this.onTap});

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard>
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final course = widget.course;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 26,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${course.instructor} • ${course.totalLessons} lessons',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.45),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: course.progress,
                          minHeight: 5,
                          backgroundColor: isDark
                              ? Colors.white.withOpacity(0.08)
                              : const Color(0xFFF0EBF0),
                          valueColor: AlwaysStoppedAnimation(AppTheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(course.progress * 100).round()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
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

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/course_detail_model.dart';
import '../services/course_service.dart';
import '../services/api_service.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;
  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  CourseDetailModel? _course;
  bool _isLoading = true;
  String? _error;
  bool _enrolling = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fetchCourse();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _fetchCourse() async {
    setState(() { _isLoading = true; _error = null; });

    try {
      final data = await CourseService.getCourseById(widget.courseId);
      if (mounted) {
        setState(() {
          _course = CourseDetailModel.fromJson(data);
          _isLoading = false;
        });
        _fadeController.forward();
      }
    } on ApiException catch (e) {
      if (mounted) setState(() { _error = e.message; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = 'Connection error: $e'; _isLoading = false; });
    }
  }

  Future<void> _handleEnroll() async {
    if (_course == null || _enrolling) return;
    setState(() => _enrolling = true);

    try {
      if (_course!.isEnrolled) {
        await CourseService.unenroll(_course!.id);
      } else {
        await CourseService.enroll(_course!.id);
      }
      // Refresh course data
      await _fetchCourse();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _enrolling = false);
    }
  }

  int get _completedCount =>
      _course?.lessons.where((l) => l.status == LessonStatus.completed).length ?? 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _fetchCourse, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final course = _course!;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              // ─── App Bar ──────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 24, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                        ),
                        child: Icon(Icons.arrow_back_ios_new_rounded, size: 18,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(course.name,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),

              // ─── Scrollable Content ───────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  children: [
                    // Progress Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
                            blurRadius: 16, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Progress', style: TextStyle(fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.onSurface)),
                              const Spacer(),
                              Text('${(course.progress * 100).round()}%',
                                  style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.w800, color: AppTheme.primary)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: course.progress,
                              minHeight: 8,
                              backgroundColor: isDark
                                  ? Colors.white.withOpacity(0.08)
                                  : const Color(0xFFF0EBF0),
                              valueColor: AlwaysStoppedAnimation(AppTheme.primary),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('$_completedCount of ${course.totalLessons} lessons completed',
                              style: TextStyle(fontSize: 13,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45))),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Stats Pills
                    Row(
                      children: [
                        _StatPill(icon: Icons.menu_book_rounded,
                            value: '${course.totalLessons}', label: 'Lessons'),
                        const SizedBox(width: 10),
                        _StatPill(icon: Icons.access_time_rounded,
                            value: course.totalDuration, label: 'Duration'),
                        const SizedBox(width: 10),
                        _StatPill(icon: Icons.star_outline_rounded,
                            value: '${course.credits}', label: 'Credits'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Instructor
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                            blurRadius: 10, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46, height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primary.withOpacity(0.1),
                            ),
                            child: Icon(Icons.person_rounded, size: 26, color: AppTheme.primary),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(course.instructor,
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                                        color: Theme.of(context).colorScheme.onSurface)),
                                const SizedBox(height: 2),
                                Text(course.instructorRole,
                                    style: TextStyle(fontSize: 13,
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45))),
                              ],
                            ),
                          ),
                          Icon(Icons.mail_outline_rounded, size: 22,
                              color: AppTheme.primary.withOpacity(0.6)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Lessons header
                    Text('Syllabus',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 14),

                    // Lesson cards
                    ...List.generate(course.lessons.length, (index) {
                      final lesson = course.lessons[index];
                      return _LessonCard(lesson: lesson, index: index);
                    }),

                    // Resources
                    if (course.resources.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text('Resources',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface)),
                      const SizedBox(height: 14),
                      ...course.resources.map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
                                blurRadius: 8, offset: const Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF2196F3).withOpacity(0.12),
                                ),
                                child: const Icon(Icons.description_outlined, size: 18,
                                    color: Color(0xFF2196F3)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(r, style: TextStyle(fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.onSurface)),
                              ),
                              Icon(Icons.download_rounded, size: 20,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                            ],
                          ),
                        ),
                      )),
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // ─── Bottom CTA (Enroll / Continue) ─────
              Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF141414) : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                      blurRadius: 16, offset: const Offset(0, -4)),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: GestureDetector(
                    onTap: _enrolling ? null : _handleEnroll,
                    child: Container(
                      width: double.infinity, height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [AppTheme.primary, AppTheme.primaryLight],
                          begin: Alignment.topLeft, end: Alignment.bottomRight),
                        boxShadow: [
                          BoxShadow(color: AppTheme.primary.withOpacity(0.35),
                              blurRadius: 16, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _enrolling
                              ? 'Please wait...'
                              : course.isEnrolled
                                  ? (course.progress > 0 ? 'Continue Learning' : 'Unenroll')
                                  : 'Start Course',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                              color: Colors.white, letterSpacing: 0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stat Pill ───────────────────────────────────────
class _StatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatPill({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F5F8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppTheme.primary),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4))),
          ],
        ),
      ),
    );
  }
}

// ── Lesson Card ─────────────────────────────────────
class _LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final int index;
  const _LessonCard({required this.lesson, required this.index});

  IconData get _statusIcon {
    switch (lesson.status) {
      case LessonStatus.completed: return Icons.check_circle_rounded;
      case LessonStatus.current: return Icons.play_circle_filled_rounded;
      case LessonStatus.locked: return Icons.lock_rounded;
    }
  }

  Color get _statusColor {
    switch (lesson.status) {
      case LessonStatus.completed: return const Color(0xFF4CAF50);
      case LessonStatus.current: return AppTheme.primary;
      case LessonStatus.locked: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLocked = lesson.status == LessonStatus.locked;
    final isCurrent = lesson.status == LessonStatus.current;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppTheme.primary.withOpacity(isDark ? 0.15 : 0.06)
            : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(14),
        border: isCurrent ? Border.all(color: AppTheme.primary.withOpacity(0.3), width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
            blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Lesson number
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _statusColor.withOpacity(0.12),
            ),
            child: Center(
              child: Text(lesson.number,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                      color: _statusColor)),
            ),
          ),
          const SizedBox(width: 14),
          // Lesson info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lesson.title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                        color: isLocked
                            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.4)
                            : Theme.of(context).colorScheme.onSurface),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text(lesson.duration,
                    style: TextStyle(fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4))),
              ],
            ),
          ),
          // Status icon
          Icon(_statusIcon, size: 22, color: _statusColor),
        ],
      ),
    );
  }
}

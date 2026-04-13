import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/course_detail_model.dart';
import '../helpers/course_detail_data.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseName;
  const CourseDetailScreen({super.key, required this.courseName});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late CourseDetailModel _course;

  @override
  void initState() {
    super.initState();
    _course = getCourseDetail(widget.courseName);
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  int get _completedCount =>
      _course.lessons.where((l) => l.status == LessonStatus.completed).length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              // ─── App Bar ────────────────────────────
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
                          color: Theme.of(context)
                              .colorScheme.onSurface.withOpacity(0.05),
                        ),
                        child: Icon(Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _course.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Scrollable Content ─────────────────
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
                              Text('Progress',
                                  style: TextStyle(fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).colorScheme.onSurface)),
                              const Spacer(),
                              Text('${(_course.progress * 100).round()}%',
                                  style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.primary)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: _course.progress,
                              minHeight: 8,
                              backgroundColor: isDark
                                  ? Colors.white.withOpacity(0.08)
                                  : const Color(0xFFF0EBF0),
                              valueColor: AlwaysStoppedAnimation(AppTheme.primary),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('$_completedCount of ${_course.totalLessons} lessons completed',
                              style: TextStyle(fontSize: 13,
                                  color: Theme.of(context)
                                      .colorScheme.onSurface.withOpacity(0.45))),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Stats Pills
                    Row(
                      children: [
                        _StatPill(icon: Icons.menu_book_rounded,
                            value: '${_course.totalLessons}', label: 'Lessons'),
                        const SizedBox(width: 10),
                        _StatPill(icon: Icons.access_time_rounded,
                            value: _course.totalDuration, label: 'Duration'),
                        const SizedBox(width: 10),
                        _StatPill(icon: Icons.star_outline_rounded,
                            value: '${_course.credits}', label: 'Credits'),
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
                            child: Icon(Icons.person_rounded, size: 26,
                                color: AppTheme.primary),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_course.instructor,
                                    style: TextStyle(fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).colorScheme.onSurface)),
                                const SizedBox(height: 2),
                                Text(_course.instructorRole,
                                    style: TextStyle(fontSize: 13,
                                        color: Theme.of(context)
                                            .colorScheme.onSurface.withOpacity(0.45))),
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
                    ...List.generate(_course.lessons.length, (index) {
                      return _LessonCard(
                        lesson: _course.lessons[index],
                        delay: index,
                      );
                    }),

                    // Resources
                    if (_course.resources.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text('Resources',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface)),
                      const SizedBox(height: 14),
                      ..._course.resources.map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E1E1E)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                    isDark ? 0.15 : 0.04),
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
                                child: const Icon(Icons.description_outlined,
                                    size: 18, color: Color(0xFF2196F3)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(r,
                                    style: TextStyle(fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme.onSurface)),
                              ),
                              Icon(Icons.download_rounded, size: 20,
                                  color: Theme.of(context)
                                      .colorScheme.onSurface.withOpacity(0.3)),
                            ],
                          ),
                        ),
                      )),
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // ─── Bottom CTA ─────────────────────────
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
                  child: _CTAButton(
                    label: _course.progress > 0
                        ? 'Continue Learning'
                        : 'Start Course',
                    onTap: () {},
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

// ── Stat Pill ─────────────────────────────────────────
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
            Text(value,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .colorScheme.onSurface.withOpacity(0.4))),
          ],
        ),
      ),
    );
  }
}

// ── Lesson Card ──────────────────────────────────────
class _LessonCard extends StatefulWidget {
  final LessonModel lesson;
  final int delay;
  const _LessonCard({required this.lesson, this.delay = 0});

  @override
  State<_LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<_LessonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: 50 * widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData get _statusIcon {
    switch (widget.lesson.status) {
      case LessonStatus.completed: return Icons.check_circle_rounded;
      case LessonStatus.current: return Icons.play_circle_filled_rounded;
      case LessonStatus.locked: return Icons.lock_rounded;
    }
  }

  Color get _statusColor {
    switch (widget.lesson.status) {
      case LessonStatus.completed: return const Color(0xFF4CAF50);
      case LessonStatus.current: return AppTheme.primary;
      case LessonStatus.locked: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLocked = widget.lesson.status == LessonStatus.locked;
    final isCurrent = widget.lesson.status == LessonStatus.current;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: GestureDetector(
          onTapDown: isLocked ? null : (_) => setState(() => _isPressed = true),
          onTapUp: isLocked ? null : (_) {
            setState(() => _isPressed = false);
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isCurrent
                  ? (isDark
                      ? AppTheme.primary.withOpacity(0.1)
                      : AppTheme.primary.withOpacity(0.06))
                  : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
              borderRadius: BorderRadius.circular(14),
              border: isCurrent
                  ? Border.all(color: AppTheme.primary.withOpacity(0.3), width: 1.5)
                  : null,
              boxShadow: [
                if (!isLocked)
                  BoxShadow(
                    color: Colors.black.withOpacity(
                        isDark ? (_isPressed ? 0.1 : 0.15) : (_isPressed ? 0.02 : 0.04)),
                    blurRadius: _isPressed ? 4 : 10,
                    offset: Offset(0, _isPressed ? 1 : 2),
                  ),
              ],
            ),
            child: Row(
              children: [
                // Number
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrent
                        ? AppTheme.primary
                        : (isDark
                            ? Colors.white.withOpacity(0.06)
                            : const Color(0xFFF0EBF0)),
                  ),
                  child: Center(
                    child: Text(
                      widget.lesson.number,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isCurrent
                            ? Colors.white
                            : Theme.of(context)
                                .colorScheme.onSurface.withOpacity(isLocked ? 0.3 : 0.6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Title + Duration
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.lesson.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                          color: Theme.of(context)
                              .colorScheme.onSurface.withOpacity(isLocked ? 0.35 : 1),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.lesson.duration,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme.onSurface.withOpacity(isLocked ? 0.2 : 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                // Status icon
                Icon(_statusIcon, size: 24, color: _statusColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── CTA Button ───────────────────────────────────────
class _CTAButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  const _CTAButton({required this.label, this.onTap});

  @override
  State<_CTAButton> createState() => _CTAButtonState();
}

class _CTAButtonState extends State<_CTAButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: _isPressed
                ? [AppTheme.primaryDark, AppTheme.primary]
                : [AppTheme.primary, AppTheme.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: _isPressed ? [] : [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.35),
              blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Center(
          child: Text(widget.label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                  color: Colors.white, letterSpacing: 0.3)),
        ),
      ),
    );
  }
}

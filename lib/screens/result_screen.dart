import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../helpers/nav_helper.dart';
import '../models/grade_model.dart';
import '../widgets/bottom_nav_bar.dart';

class ResultScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const ResultScreen({super.key, this.onToggleTheme});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  String _selectedFilter = 'Final Grades';
  String _selectedSemester = 'Semester';

  final List<String> _filterOptions = ['Final Grades', 'Midterm', 'Quizzes'];
  final List<String> _semesterOptions = ['Semester', 'S2023', 'S2024', 'F2023', 'F2024'];

  final List<GradeModel> _grades = [
    GradeModel(courseName: 'Digital Marketing', grade: 'A+', semester: 'S2023',
        gradeColor: AppTheme.primary),
    GradeModel(courseName: 'Design Learning', grade: 'B', semester: 'S2023',
        gradeColor: AppTheme.primary),
    GradeModel(courseName: 'Software Management', grade: 'B+', semester: 'S2023',
        gradeColor: AppTheme.primary),
    GradeModel(courseName: 'Digital Logical Thoughts', grade: 'C', semester: 'S2023',
        gradeColor: AppTheme.primary),
    GradeModel(courseName: 'Artifical Intelligence', grade: 'F', semester: 'S2023',
        gradeColor: AppTheme.primary),
    GradeModel(courseName: 'Physics', grade: 'A+', semester: 'S2023',
        gradeColor: AppTheme.primary),
    GradeModel(courseName: 'Mathematics', grade: 'C+', semester: 'S2023',
        gradeColor: AppTheme.primary),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+': case 'A': return AppTheme.primary;
      case 'B+': case 'B': return AppTheme.primary;
      case 'C+': case 'C': return AppTheme.primary;
      case 'D+': case 'D': return Colors.orange;
      case 'F': return Colors.red;
      default: return AppTheme.primary;
    }
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
              // ─── App Bar with dark mode toggle ────
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              //   child: Row(
              //     children: [
              //       GestureDetector(
              //         onTap: widget.onToggleTheme,
              //         child: Container(
              //           width: 42, height: 42,
              //           decoration: BoxDecoration(shape: BoxShape.circle,
              //               color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
              //           child: Icon(
              //             Theme.of(context).brightness == Brightness.dark
              //                 ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              //             size: 22,
              //             color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
              //         ),
              //       ),
              //       const Spacer(),
              //     ],
              //   ),
              // ),

              // ─── Header ─────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Grades: ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          TextSpan(
                            text: _selectedFilter,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppTheme.primary, size: 28),
                      onSelected: (value) {
                        setState(() => _selectedFilter = value);
                      },
                      itemBuilder: (context) => _filterOptions
                          .map((f) => PopupMenuItem(value: f, child: Text(f)))
                          .toList(),
                    ),
                    GestureDetector(
                      onTap: widget.onToggleTheme,
                      child: Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
                        child: Icon(
                          Theme.of(context).brightness == Brightness.dark
                              ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                          size: 22,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                      ),
                    ),
                  ],
                ),
              ),

              // ─── CGPA & Credits ─────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Overall CGPA: ',
                                style: TextStyle(fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onSurface)),
                            Text('4.00',
                                style: TextStyle(fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primary)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('Credits earned: ',
                                style: TextStyle(fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                            Text('50/150',
                                style: TextStyle(fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                          ],
                        ),
                      ],
                    ),
                    // Semester dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSemester,
                          isDense: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface),
                          items: _semesterOptions
                              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) setState(() => _selectedSemester = value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ─── Grades List ────────────────────────
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF141414)
                        : const Color(0xFFF0EBF0),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    itemCount: _grades.length,
                    itemBuilder: (context, index) {
                      return _GradeCard(
                        grade: _grades[index],
                        gradeColor: _getGradeColor(_grades[index].grade),
                        delay: index,
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
        currentIndex: 3,
        onTap: (index) {
          handleNavTap(
            context: context,
            currentIndex: 3,
            tappedIndex: index,
            onToggleTheme: widget.onToggleTheme,
          );
        },
      ),
    );
  }
}

class _GradeCard extends StatefulWidget {
  final GradeModel grade;
  final Color gradeColor;
  final int delay;
  const _GradeCard({required this.grade, required this.gradeColor, this.delay = 0});

  @override
  State<_GradeCard> createState() => _GradeCardState();
}

class _GradeCardState extends State<_GradeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
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
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Course name
              Expanded(
                child: Text(
                  widget.grade.courseName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Grade + Semester badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFFF5F2F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.grade.grade,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: widget.gradeColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.grade.semester,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.45),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

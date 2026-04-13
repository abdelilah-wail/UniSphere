import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/schedule_model.dart';

void showScheduleDetail(BuildContext context, ScheduleModel item) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) => _ScheduleDetailSheet(item: item),
  );
}

class _ScheduleDetailSheet extends StatelessWidget {
  final ScheduleModel item;
  const _ScheduleDetailSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Container(
        margin: const EdgeInsets.only(top: 120),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141414) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.5 : 0.15),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme.onSurface.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header with close
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 12, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Class Details',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onSurface)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context)
                            .colorScheme.onSurface.withOpacity(0.06),
                      ),
                      child: Icon(Icons.close_rounded, size: 20,
                          color: Theme.of(context)
                              .colorScheme.onSurface.withOpacity(0.5)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Color banner with course name
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: item.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.courseName,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                          color: item.textColor, height: 1.2)),
                  const SizedBox(height: 6),
                  Text(item.lectureInfo,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,
                          color: item.textColor.withOpacity(0.7))),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Meta rows
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _MetaRow(
                    icon: Icons.access_time_rounded,
                    iconColor: AppTheme.primary,
                    label: 'Time',
                    value: '${item.startTime} – ${item.endTime}',
                  ),
                  const SizedBox(height: 12),
                  _MetaRow(
                    icon: Icons.location_on_outlined,
                    iconColor: const Color(0xFF4CAF50),
                    label: 'Room',
                    value: item.room,
                  ),
                  const SizedBox(height: 12),
                  _MetaRow(
                    icon: Icons.person_outline_rounded,
                    iconColor: const Color(0xFFFF9800),
                    label: 'Instructor',
                    value: item.teacher,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Notification
                    _CircleAction(
                      icon: Icons.notifications_none_rounded,
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                    // Share
                    _CircleAction(
                      icon: Icons.share_outlined,
                      onTap: () {},
                    ),
                    const SizedBox(width: 16),
                    // Join class
                    Expanded(
                      child: _CTAButton(
                        label: 'Join Class',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  const _MetaRow({required this.icon, required this.iconColor,
      required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F5F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(shape: BoxShape.circle,
                color: iconColor.withOpacity(0.12)),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .colorScheme.onSurface.withOpacity(0.4))),
                const SizedBox(height: 3),
                Text(value, style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CircleAction({required this.icon, this.onTap});
  @override
  State<_CircleAction> createState() => _CircleActionState();
}

class _CircleActionState extends State<_CircleAction> {
  bool _p = false;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTapDown: (_) => setState(() => _p = true),
      onTapUp: (_) { setState(() => _p = false); widget.onTap?.call(); },
      onTapCancel: () => setState(() => _p = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48, height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _p
              ? (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E3E8))
              : (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF0EBF0)),
          border: Border.all(color: Theme.of(context)
              .colorScheme.onSurface.withOpacity(0.08)),
        ),
        child: Icon(widget.icon, size: 22,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
      ),
    );
  }
}

class _CTAButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  const _CTAButton({required this.label, this.onTap});
  @override
  State<_CTAButton> createState() => _CTAButtonState();
}

class _CTAButtonState extends State<_CTAButton> {
  bool _p = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _p = true),
      onTapUp: (_) { setState(() => _p = false); widget.onTap?.call(); },
      onTapCancel: () => setState(() => _p = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: _p
                ? [AppTheme.primaryDark, AppTheme.primary]
                : [AppTheme.primary, AppTheme.primaryLight],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          boxShadow: _p ? [] : [
            BoxShadow(color: AppTheme.primary.withOpacity(0.35),
                blurRadius: 14, offset: const Offset(0, 5)),
          ],
        ),
        child: Center(
          child: Text(widget.label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ),
      ),
    );
  }
}

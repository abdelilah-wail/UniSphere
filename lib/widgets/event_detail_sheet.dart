import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/event_model.dart';

void showEventDetail(BuildContext context, EventModel event) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) => _EventDetailSheet(event: event),
  );
}

class _EventDetailSheet extends StatelessWidget {
  final EventModel event;
  const _EventDetailSheet({required this.event});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: DraggableScrollableSheet(
        initialChildSize: 0.88,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
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
              children: [
                // ─── Drag Handle ────────────────────
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

                // ─── Scrollable Content ─────────────
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      // Hero Image + Close button
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: Image.network(
                              event.imageUrl,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 220,
                                color: isDark
                                    ? const Color(0xFF1E1E1E)
                                    : const Color(0xFFF0EBF0),
                                child: Center(
                                  child: Icon(Icons.event_rounded,
                                      size: 56,
                                      color: AppTheme.primary.withOpacity(0.25)),
                                ),
                              ),
                            ),
                          ),
                          // Gradient overlay
                          Positioned(
                            bottom: 0, left: 0, right: 0,
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    (isDark ? const Color(0xFF141414) : Colors.white)
                                        .withOpacity(0.9),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Close button
                          Positioned(
                            top: 12, right: 16,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 38, height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                child: const Icon(Icons.close_rounded,
                                    size: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Content below image
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              event.title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Meta info cards
                            _MetaRow(
                              icon: Icons.calendar_today_rounded,
                              iconColor: AppTheme.primary,
                              label: 'Date',
                              value: event.date,
                              subValue: event.time,
                            ),
                            const SizedBox(height: 12),
                            _MetaRow(
                              icon: Icons.location_on_outlined,
                              iconColor: const Color(0xFF4CAF50),
                              label: 'Location',
                              value: event.location,
                              subValue: event.venue,
                            ),
                            if (event.organizer != null &&
                                event.organizer!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _MetaRow(
                                icon: Icons.groups_outlined,
                                iconColor: const Color(0xFFFF9800),
                                label: 'Organized by',
                                value: event.organizer!,
                              ),
                            ],

                            const SizedBox(height: 28),

                            // About section
                            Text(
                              'About this event',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              event.description.isNotEmpty
                                  ? event.description
                                  : 'Join us for ${event.title} in ${event.location}. This event brings together students, educators, and professionals for an enriching experience. Don\'t miss this opportunity to learn, connect, and grow.',
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.8,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    .colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Action buttons
                            Row(
                              children: [
                                // Share
                                _CircleAction(
                                  icon: Icons.share_outlined,
                                  onTap: () {},
                                ),
                                const SizedBox(width: 12),
                                // Add to calendar
                                _CircleAction(
                                  icon: Icons.bookmark_border_rounded,
                                  onTap: () {},
                                ),
                                const SizedBox(width: 16),
                                // Register CTA
                                Expanded(
                                  child: _CTAButton(
                                    label: 'Register Now',
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Meta Info Row ───────────────────────────────────────
class _MetaRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? subValue;

  const _MetaRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.subValue,
  });

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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.12),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme.onSurface.withOpacity(0.4))),
                const SizedBox(height: 3),
                Text(value,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface)),
                if (subValue != null && subValue!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(subValue!,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,
                          color: Theme.of(context)
                              .colorScheme.onSurface.withOpacity(0.5))),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Circle Action Button ───────────────────────────────
class _CircleAction extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CircleAction({required this.icon, this.onTap});

  @override
  State<_CircleAction> createState() => _CircleActionState();
}

class _CircleActionState extends State<_CircleAction> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48, height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isPressed
              ? (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E3E8))
              : (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF0EBF0)),
          border: Border.all(
            color: Theme.of(context)
                .colorScheme.onSurface.withOpacity(0.08),
          ),
        ),
        child: Icon(widget.icon, size: 22,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
      ),
    );
  }
}

// ── Primary CTA Button ─────────────────────────────────
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
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: _isPressed
                ? [AppTheme.primaryDark, AppTheme.primary]
                : [AppTheme.primary, AppTheme.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

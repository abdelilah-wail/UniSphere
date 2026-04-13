import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _profileVisible = true;
  bool _showEmail = false;
  bool _dataSharing = true;
  bool _activityStatus = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 24, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 18,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Privacy', style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface)),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                children: [
                  // ─── Visibility ─────────────────────
                  _SectionHeader(title: 'Visibility'),
                  const SizedBox(height: 14),
                  _Card(
                    child: Column(
                      children: [
                        _ToggleRow(
                          icon: Icons.visibility_outlined,
                          iconColor: const Color(0xFF4CAF50),
                          title: 'Profile Visible',
                          subtitle: 'Others can see your profile',
                          value: _profileVisible,
                          onChanged: (v) => setState(() => _profileVisible = v),
                        ),
                        _divider(context),
                        _ToggleRow(
                          icon: Icons.alternate_email_rounded,
                          iconColor: const Color(0xFF2196F3),
                          title: 'Show Email',
                          subtitle: 'Display email on your profile',
                          value: _showEmail,
                          onChanged: (v) => setState(() => _showEmail = v),
                        ),
                        _divider(context),
                        _ToggleRow(
                          icon: Icons.circle_outlined,
                          iconColor: const Color(0xFFFF9800),
                          title: 'Activity Status',
                          subtitle: 'Show when you\'re online',
                          value: _activityStatus,
                          onChanged: (v) => setState(() => _activityStatus = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─── Data ──────────────────────────
                  _SectionHeader(title: 'Data & Storage'),
                  const SizedBox(height: 14),
                  _Card(
                    child: Column(
                      children: [
                        _ToggleRow(
                          icon: Icons.share_outlined,
                          iconColor: const Color(0xFF9C27B0),
                          title: 'Data Sharing',
                          subtitle: 'Share usage data for improvements',
                          value: _dataSharing,
                          onChanged: (v) => setState(() => _dataSharing = v),
                        ),
                        _divider(context),
                        _NavRow(
                          icon: Icons.download_outlined,
                          iconColor: const Color(0xFF0097A7),
                          title: 'Download My Data',
                          onTap: () {},
                        ),
                        _divider(context),
                        _NavRow(
                          icon: Icons.cleaning_services_outlined,
                          iconColor: const Color(0xFF607D8B),
                          title: 'Clear Cache',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─── Danger Zone ────────────────────
                  _SectionHeader(title: 'Danger Zone'),
                  const SizedBox(height: 14),
                  _Card(
                    borderColor: Colors.red.withOpacity(0.2),
                    child: Column(
                      children: [
                        _NavRow(
                          icon: Icons.person_off_outlined,
                          iconColor: Colors.red,
                          title: 'Deactivate Account',
                          titleColor: Colors.red.shade700,
                          onTap: () {},
                        ),
                        _divider(context),
                        _NavRow(
                          icon: Icons.delete_outline_rounded,
                          iconColor: Colors.red,
                          title: 'Delete Account',
                          titleColor: Colors.red.shade700,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) => Divider(height: 1,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.06));
}

// Shared components (same pattern as settings)
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface));
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  const _Card({required this.child, this.borderColor});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: borderColor ?? AppTheme.primary.withOpacity(0.15), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
              blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.icon, required this.iconColor,
      required this.title, this.subtitle, required this.value,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(width: 40, height: 40,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  color: iconColor.withOpacity(0.12)),
              child: Icon(icon, size: 20, color: iconColor)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: TextStyle(fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4))),
                ],
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged,
              activeColor: AppTheme.primary),
        ],
      ),
    );
  }
}

class _NavRow extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color? titleColor;
  final VoidCallback? onTap;
  const _NavRow({required this.icon, required this.iconColor,
      required this.title, this.titleColor, this.onTap});
  @override
  State<_NavRow> createState() => _NavRowState();
}

class _NavRowState extends State<_NavRow> {
  bool _p = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _p = true),
      onTapUp: (_) { setState(() => _p = false); widget.onTap?.call(); },
      onTapCancel: () => setState(() => _p = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: _p ? Theme.of(context).colorScheme.onSurface.withOpacity(0.03)
            : Colors.transparent,
        child: Row(
          children: [
            Container(width: 40, height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    color: widget.iconColor.withOpacity(0.12)),
                child: Icon(widget.icon, size: 20, color: widget.iconColor)),
            const SizedBox(width: 14),
            Expanded(child: Text(widget.title, style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.w600,
                color: widget.titleColor ?? Theme.of(context).colorScheme.onSurface))),
            Icon(Icons.chevron_right_rounded, size: 22,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25)),
          ],
        ),
      ),
    );
  }
}

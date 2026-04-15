import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../helpers/nav_helper.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../services/api_service.dart';
import '../widgets/bottom_nav_bar.dart';
import 'settings_screen.dart';
import 'privacy_screen.dart';
import '../models/notification_model.dart';
import '../helpers/notification_helper.dart';
import '../widgets/notification_bell.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const ProfileScreen({super.key, this.onToggleTheme});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  UserModel? _user;
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
    _fetchProfile();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await UserService.getProfile();
      if (mounted) {
        setState(() {
          _user = UserModel.fromJson(data);
          _isLoading = false;
        });
        _fadeController.forward();
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Connection error: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
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
                      onPressed: _fetchProfile,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : FadeTransition(
                opacity: _fadeAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Header with Theme & Notification ─────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left: Title
                            Expanded(
                              child: Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
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
                      // ─── Avatar + Name (FROM API) ─────────
                      Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.primary,
                                width: 2.5,
                              ),
                            ),
                            child: ClipOval(
                              child: Container(
                                color: isDark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 44,
                                  color: isDark
                                      ? Colors.grey.shade500
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _user!.name,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _user!.studentId ?? 'No Student ID',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ─── Stats Row (FROM API) ─────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1A1A1A)
                              : const Color(0xFFF0EBF0),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              value:
                                  '${_user!.creditsEarned}/${_user!.totalCredits}',
                              label: 'Credit earns',
                              valueColor: AppTheme.primary,
                            ),
                            Container(
                              width: 1,
                              height: 36,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.1),
                            ),
                            _StatItem(
                              value: _user!.gpa.toStringAsFixed(2),
                              label: 'GPA',
                              valueColor: AppTheme.primary,
                            ),
                            Container(
                              width: 1,
                              height: 36,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.1),
                            ),
                            _StatItem(
                              value: '${_user!.yearLevel}',
                              label: 'Year student',
                              valueColor: AppTheme.primary,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ─── Statistics Card ────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1A1A1A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppTheme.primary.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Statistics',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Monday, 06 June 2024',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF4CAF50,
                                    ).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Mark Attend',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _CircleStat(
                                    icon: Icons.co_present_rounded,
                                    iconBgColor: const Color(0xFFFFC107),
                                    label: 'Attendance',
                                    value: '90%',
                                  ),
                                ),
                                Expanded(
                                  child: _CircleStat(
                                    icon: Icons.task_alt_rounded,
                                    iconBgColor: const Color(0xFF9C27B0),
                                    label: 'Task & Work',
                                    value: '70%',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _CircleStat(
                              icon: Icons.quiz_rounded,
                              iconBgColor: const Color(0xFFFF5722),
                              label: 'Quiz',
                              value: '85%',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ─── Dashboard Card ─────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1A1A1A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppTheme.primary.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dashboard',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.45),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _DashboardItem(
                              icon: Icons.settings_outlined,
                              iconColor: const Color(0xFF0097A7),
                              label: 'Setting',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SettingsScreen(
                                      onToggleTheme: widget.onToggleTheme,
                                    ),
                                  ),
                                ).then(
                                  (_) => _fetchProfile(),
                                ); // Refresh after settings change
                              },
                            ),
                            const SizedBox(height: 12),
                            _DashboardItem(
                              icon: Icons.star_outline_rounded,
                              iconColor: const Color(0xFF9C27B0),
                              label: 'Achivement',
                              onTap: () {},
                            ),
                            const SizedBox(height: 12),
                            _DashboardItem(
                              icon: Icons.lock_outline_rounded,
                              iconColor: const Color(0xFFFF9800),
                              label: 'Privacy',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PrivacyScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),

      // Bottom Nav
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          handleNavTap(
            context: context,
            currentIndex: 4,
            tappedIndex: index,
            onToggleTheme: widget.onToggleTheme,
          );
        },
      ),
    );
  }
}

// ── Stat Item ─────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  const _StatItem({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

// ── Circle Stat ───────────────────────────────────────
class _CircleStat extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String label;
  final String value;
  const _CircleStat({
    required this.icon,
    required this.iconBgColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconBgColor.withOpacity(0.15),
          ),
          child: Icon(icon, size: 22, color: iconBgColor),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.55),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Dashboard Item ────────────────────────────────────
class _DashboardItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback? onTap;
  const _DashboardItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.12),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 24,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
          ),
        ],
      ),
    );
  }
}

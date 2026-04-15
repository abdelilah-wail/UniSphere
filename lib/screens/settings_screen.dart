import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'sign_in_screen.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const SettingsScreen({super.key, this.onToggleTheme});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _darkMode = false;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _currentPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _darkMode = Theme.of(context).brightness == Brightness.dark;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    super.dispose();
  }

  // ─── Load profile from API ────────────────────────
  Future<void> _loadProfile() async {
    try {
      final data = await UserService.getProfile();
      final user = UserModel.fromJson(data);
      if (mounted) {
        setState(() {
          _nameCtrl.text = user.name;
          _emailCtrl.text = user.email;
          _pushNotifications = user.preferences.pushNotifications;
          _emailNotifications = user.preferences.emailNotifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── Save profile changes ─────────────────────────
  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);

    try {
      await UserService.updateProfile(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        preferences: {
          'pushNotifications': _pushNotifications,
          'emailNotifications': _emailNotifications,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      }
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
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ─── Change password ──────────────────────────────
  Future<void> _handleChangePassword() async {
    final current = _currentPassCtrl.text.trim();
    final newPass = _newPassCtrl.text.trim();

    if (current.isEmpty || newPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both password fields'),
            backgroundColor: Colors.orange),
      );
      return;
    }

    if (newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password must be at least 6 characters'),
            backgroundColor: Colors.orange),
      );
      return;
    }

    try {
      await UserService.changePassword(
        currentPassword: current,
        newPassword: newPass,
      );

      if (mounted) {
        _currentPassCtrl.clear();
        _newPassCtrl.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password changed successfully!'),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
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
    }
  }

  // ─── Logout ───────────────────────────────────────
  Future<void> _handleLogout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => SignInScreen(onToggleTheme: widget.onToggleTheme)),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                  Text('Settings', style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface)),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                children: [
                  // ─── Profile Edit Section ─────────────
                  _SectionHeader(title: 'Profile'),
                  const SizedBox(height: 14),
                  _Card(
                    child: Column(
                      children: [
                        // Avatar
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 80, height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.primary, width: 2.5),
                                ),
                                child: ClipOval(
                                  child: Container(
                                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                                    child: Icon(Icons.person_rounded, size: 48,
                                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0, right: 0,
                                child: Container(
                                  width: 28, height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: AppTheme.primary,
                                    border: Border.all(
                                      color: isDark ? const Color(0xFF1A1A1A) : Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _InputField(label: 'Full Name', controller: _nameCtrl,
                            icon: Icons.person_outline_rounded),
                        const SizedBox(height: 12),
                        _InputField(label: 'Email', controller: _emailCtrl,
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─── Preferences ────────────────────
                  _SectionHeader(title: 'Preferences'),
                  const SizedBox(height: 14),
                  _Card(
                    child: Column(
                      children: [
                        _ToggleRow(
                          icon: Icons.notifications_none_rounded,
                          iconColor: const Color(0xFFFF9800),
                          title: 'Push Notifications',
                          value: _pushNotifications,
                          onChanged: (v) => setState(() => _pushNotifications = v),
                        ),
                        _divider(context),
                        _ToggleRow(
                          icon: Icons.email_outlined,
                          iconColor: const Color(0xFF2196F3),
                          title: 'Email Notifications',
                          value: _emailNotifications,
                          onChanged: (v) => setState(() => _emailNotifications = v),
                        ),
                        _divider(context),
                        _ToggleRow(
                          icon: Icons.dark_mode_outlined,
                          iconColor: const Color(0xFF9C27B0),
                          title: 'Dark Mode',
                          value: _darkMode,
                          onChanged: (v) {
                            setState(() => _darkMode = v);
                            widget.onToggleTheme?.call();
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─── Security ───────────────────────
                  _SectionHeader(title: 'Security'),
                  const SizedBox(height: 14),
                  _Card(
                    child: Column(
                      children: [
                        _InputField(label: 'Current Password', controller: _currentPassCtrl,
                            icon: Icons.lock_outline_rounded, obscureText: true),
                        const SizedBox(height: 12),
                        _InputField(label: 'New Password', controller: _newPassCtrl,
                            icon: Icons.lock_reset_rounded, obscureText: true),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _handleChangePassword,
                          child: Container(
                            width: double.infinity, height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppTheme.primary.withOpacity(0.1),
                            ),
                            child: Center(
                              child: Text('Change Password',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                                      color: AppTheme.primary)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─── About ─────────────────────────
                  _SectionHeader(title: 'About'),
                  const SizedBox(height: 14),
                  _Card(
                    child: Column(
                      children: [
                        _NavRow(icon: Icons.info_outline_rounded,
                            iconColor: const Color(0xFF2196F3),
                            title: 'App Version', trailing: 'v2.1.0'),
                        _divider(context),
                        _NavRow(icon: Icons.description_outlined,
                            iconColor: const Color(0xFF9C27B0),
                            title: 'Terms of Service', onTap: () {}),
                        _divider(context),
                        _NavRow(icon: Icons.logout_rounded,
                            iconColor: Colors.red,
                            title: 'Log Out', titleColor: Colors.red,
                            onTap: _handleLogout),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Save button
                  _SaveButton(
                    label: _isSaving ? 'Saving...' : 'Save Changes',
                    onTap: _isSaving ? null : _saveChanges,
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

// ── Reusable Components ───────────────────────────────

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
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.primary.withOpacity(0.15), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
              blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;
  const _InputField({required this.label, required this.controller,
      required this.icon, this.keyboardType = TextInputType.text, this.obscureText = false});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F5F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35)),
          prefixIcon: Icon(icon, size: 22, color: AppTheme.primary.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.icon, required this.iconColor,
      required this.title, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(width: 40, height: 40,
              decoration: BoxDecoration(shape: BoxShape.circle, color: iconColor.withOpacity(0.12)),
              child: Icon(icon, size: 20, color: iconColor)),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface))),
          Switch.adaptive(value: value, onChanged: onChanged, activeColor: AppTheme.primary),
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
  final String? trailing;
  final VoidCallback? onTap;
  const _NavRow({required this.icon, required this.iconColor,
      required this.title, this.titleColor, this.trailing, this.onTap});
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
        color: _p ? Theme.of(context).colorScheme.onSurface.withOpacity(0.03) : Colors.transparent,
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
            if (widget.trailing != null)
              Text(widget.trailing!, style: TextStyle(fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)))
            else
              Icon(Icons.chevron_right_rounded, size: 22,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25)),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  const _SaveButton({required this.label, this.onTap});
  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool _p = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _p = true),
      onTapUp: (_) { setState(() => _p = false); widget.onTap?.call(); },
      onTapCancel: () => setState(() => _p = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity, height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: _p ? [AppTheme.primaryDark, AppTheme.primary]
                : [AppTheme.primary, AppTheme.primaryLight],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: _p ? [] : [
            BoxShadow(color: AppTheme.primary.withOpacity(0.35),
                blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Center(child: Text(widget.label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                color: Colors.white, letterSpacing: 0.3))),
      ),
    );
  }
}

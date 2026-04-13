import 'package:flutter/material.dart';

class SocialButton extends StatefulWidget {
  final String label;
  final String iconPath; // asset path or use Icons
  final IconData? iconData;
  final VoidCallback? onPressed;

  const SocialButton({
    super.key,
    required this.label,
    this.iconPath = '',
    this.iconData,
    this.onPressed,
  });

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark
              ? Colors.white.withOpacity(_isPressed ? 0.08 : 0.05)
              : Colors.white,
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.12)
                : Colors.grey.withOpacity(0.2),
          ),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.iconData != null)
              Icon(widget.iconData, size: 22,
                  color: Theme.of(context).colorScheme.onSurface),
            if (widget.iconData != null) const SizedBox(width: 10),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

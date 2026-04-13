import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FloatingShapes extends StatefulWidget {
  const FloatingShapes({super.key});

  @override
  State<FloatingShapes> createState() => _FloatingShapesState();
}

class _FloatingShapesState extends State<FloatingShapes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = sin(_controller.value * pi) * 20;
        return Stack(
          children: [
            Positioned(
              top: 60 + offset,
              right: -40,
              child: _blob(120, AppTheme.primary.withOpacity(0.15)),
            ),
            Positioned(
              top: 200 - offset,
              left: -60,
              child: _blob(160, AppTheme.primaryLight.withOpacity(0.10)),
            ),
            Positioned(
              bottom: 100 + offset * 0.5,
              right: 20,
              child: _blob(80, AppTheme.primary.withOpacity(0.08)),
            ),
            Positioned(
              bottom: 250 - offset * 0.7,
              left: 30,
              child: _blob(60, AppTheme.primaryLight.withOpacity(0.12)),
            ),
          ],
        );
      },
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withOpacity(0)],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: size * 0.6,
            spreadRadius: size * 0.1,
          ),
        ],
      ),
    );
  }
}

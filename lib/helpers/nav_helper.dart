import 'package:flutter/material.dart';
import '../screens/courses_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/location_screen.dart';

void handleNavTap({
  required BuildContext context,
  required int currentIndex,
  required int tappedIndex,
  VoidCallback? onToggleTheme,
}) {
  if (tappedIndex == currentIndex) return;

  switch (tappedIndex) {
    case 0:
      // Go back to Home
      Navigator.popUntil(context, (route) => route.isFirst);
      break;
    case 1:
      // Go to Courses
      if (currentIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CoursesScreen(onToggleTheme: onToggleTheme),
          ),
        );
      } else {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CoursesScreen(onToggleTheme: onToggleTheme),
          ),
        );
      }
      break;
    case 2:
      // Go to Schedule
      if (currentIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScheduleScreen(onToggleTheme: onToggleTheme),
          ),
        );
      } else {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScheduleScreen(onToggleTheme: onToggleTheme),
          ),
        );
      }
      break;
    case 3:
      // Go to Location (was Result)
      if (currentIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LocationScreen(onToggleTheme: onToggleTheme),
          ),
        );
      } else {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LocationScreen(onToggleTheme: onToggleTheme),
          ),
        );
      }
      break;
    case 4:
      // Go to Profile
      if (currentIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(onToggleTheme: onToggleTheme),
          ),
        );
      } else {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(onToggleTheme: onToggleTheme),
          ),
        );
      }
      break;
  }
}

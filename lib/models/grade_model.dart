import 'package:flutter/material.dart';

class GradeModel {
  final String courseName;
  final String grade;
  final String semester;
  final Color gradeColor;

  const GradeModel({
    required this.courseName,
    required this.grade,
    required this.semester,
    this.gradeColor = const Color(0xFF63003C),
  });
}

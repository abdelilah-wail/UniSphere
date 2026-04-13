import 'package:flutter/material.dart';

class ScheduleModel {
  final String courseName;
  final String lectureInfo;
  final String startTime;
  final String endTime;
  final String room;
  final String teacher;
  final Color cardColor;
  final Color textColor;

  const ScheduleModel({
    required this.courseName,
    required this.lectureInfo,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.teacher,
    required this.cardColor,
    this.textColor = const Color(0xFF1A1A1A),
  });
}

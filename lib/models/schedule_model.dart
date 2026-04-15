import 'package:flutter/material.dart';

class ScheduleModel {
  final String id;
  final String courseName;
  final String lectureInfo;
  final String startTime;
  final String endTime;
  final String room;
  final String teacher;
  final String day;
  final Color cardColor;
  final Color textColor;

  const ScheduleModel({
    required this.id,
    required this.courseName,
    this.lectureInfo = '',
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.teacher,
    required this.day,
    required this.cardColor,
    this.textColor = const Color(0xFF1A1A1A),
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['_id'] ?? '',
      courseName: json['courseName'] ?? '',
      lectureInfo: json['lectureInfo'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      room: json['room'] ?? '',
      teacher: json['teacher'] ?? '',
      day: json['day'] ?? '',
      cardColor: _hexToColor(json['cardColor'] ?? '#F3E5F5'),
      textColor: _hexToColor(json['textColor'] ?? '#1A1A1A'),
    );
  }

  /// Convert hex string like "#F3E5F5" or "#63003C" to Flutter Color
  static Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex'; // add full opacity
    return Color(int.parse(hex, radix: 16));
  }
}

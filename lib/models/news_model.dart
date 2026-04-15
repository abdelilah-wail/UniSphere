import 'package:flutter/material.dart';

class NewsModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final Color badgeColor;
  final String? imageUrl;
  final String author;
  final String source;
  final String fullContent;

  const NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.badgeColor,
    this.imageUrl,
    this.author = 'Admin',
    this.source = '',
    this.fullContent = '',
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      badgeColor: _hexToColor(json['badgeColor'] ?? '#63003C'),
      imageUrl: json['imageUrl'],
      author: json['author'] ?? 'Admin',
      source: json['source'] ?? '',
      fullContent: json['fullContent'] ?? json['description'] ?? '',
    );
  }

  static Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}

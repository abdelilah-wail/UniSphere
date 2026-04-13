import 'package:flutter/material.dart';

class NewsModel {
  final String title;
  final String description;
  final String fullContent;
  final String date;
  final String source;
  final String? imageUrl;
  final Color badgeColor;

  const NewsModel({
    required this.title,
    required this.description,
    this.fullContent = '',
    required this.date,
    this.source = '',
    this.imageUrl,
    required this.badgeColor,
  });
}

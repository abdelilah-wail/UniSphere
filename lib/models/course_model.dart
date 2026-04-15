class CourseModel {
  final String id;
  final String name;
  final String instructor;
  final double progress;
  final int totalLessons;
  final String totalDuration;
  final String category;
  final int credits;

  const CourseModel({
    required this.id,
    required this.name,
    required this.instructor,
    this.progress = 0,
    this.totalLessons = 0,
    this.totalDuration = '0 hrs',
    this.category = 'Other',
    this.credits = 3,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      instructor: json['instructor'] ?? '',
      progress: (json['progress'] ?? 0).toDouble(),
      totalLessons: json['totalLessons'] ?? 0,
      totalDuration: json['totalDuration'] ?? '0 hrs',
      category: json['category'] ?? 'Other',
      credits: json['credits'] ?? 3,
    );
  }
}

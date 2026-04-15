

enum LessonStatus { completed, current, locked }

class LessonModel {
  final String number;
  final String title;
  final String duration;
  final LessonStatus status;

  const LessonModel({
    required this.number,
    required this.title,
    required this.duration,
    this.status = LessonStatus.locked,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    LessonStatus status;
    switch (json['status']) {
      case 'completed':
        status = LessonStatus.completed;
        break;
      case 'current':
        status = LessonStatus.current;
        break;
      default:
        status = LessonStatus.locked;
    }
    return LessonModel(
      number: json['number'] ?? '',
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      status: status,
    );
  }
}

class CourseDetailModel {
  final String id;
  final String name;
  final String instructor;
  final String instructorRole;
  final int totalLessons;
  final String totalDuration;
  final int credits;
  final double progress;
  final List<LessonModel> lessons;
  final List<String> resources;
  final String category;
  final bool isEnrolled;
  final int enrolledCount;

  const CourseDetailModel({
    required this.id,
    required this.name,
    required this.instructor,
    this.instructorRole = 'Lecturer',
    required this.totalLessons,
    required this.totalDuration,
    this.credits = 3,
    required this.progress,
    required this.lessons,
    this.resources = const [],
    this.category = 'Other',
    this.isEnrolled = false,
    this.enrolledCount = 0,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      instructor: json['instructor'] ?? '',
      instructorRole: json['instructorRole'] ?? 'Lecturer',
      totalLessons: json['totalLessons'] ?? 0,
      totalDuration: json['totalDuration'] ?? '0 hrs',
      credits: json['credits'] ?? 3,
      progress: (json['progress'] ?? 0).toDouble(),
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((l) => LessonModel.fromJson(l))
              .toList() ??
          [],
      resources: (json['resources'] as List<dynamic>?)
              ?.map((r) => r.toString())
              .toList() ??
          [],
      category: json['category'] ?? 'Other',
      isEnrolled: json['isEnrolled'] ?? false,
      enrolledCount: json['enrolledCount'] ?? 0,
    );
  }
}

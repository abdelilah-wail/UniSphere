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
}

class CourseDetailModel {
  final String name;
  final String instructor;
  final String instructorRole;
  final int totalLessons;
  final String totalDuration;
  final int credits;
  final double progress;
  final List<LessonModel> lessons;
  final List<String> resources;

  const CourseDetailModel({
    required this.name,
    required this.instructor,
    this.instructorRole = 'Lecturer',
    required this.totalLessons,
    required this.totalDuration,
    this.credits = 3,
    required this.progress,
    required this.lessons,
    this.resources = const [],
  });
}

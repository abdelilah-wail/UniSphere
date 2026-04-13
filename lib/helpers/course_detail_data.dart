import '../models/course_detail_model.dart';

CourseDetailModel getCourseDetail(String courseName) {
  final Map<String, CourseDetailModel> courses = {
    'Digital Marketing': CourseDetailModel(
      name: 'Digital Marketing',
      instructor: 'Mam Hira',
      instructorRole: 'Senior Lecturer',
      totalLessons: 12,
      totalDuration: '24 hrs',
      credits: 3,
      progress: 0.58,
      resources: ['Lecture Slides (PDF)', 'Case Studies Pack', 'Marketing Toolkit'],
      lessons: [
        LessonModel(number: '01', title: 'Introduction to Digital Marketing', duration: '45 min', status: LessonStatus.completed),
        LessonModel(number: '02', title: 'SEO Fundamentals', duration: '1 hr', status: LessonStatus.completed),
        LessonModel(number: '03', title: 'Social Media Strategy', duration: '1.5 hrs', status: LessonStatus.completed),
        LessonModel(number: '04', title: 'Content Marketing', duration: '2 hrs', status: LessonStatus.completed),
        LessonModel(number: '05', title: 'Email Marketing Campaigns', duration: '1.5 hrs', status: LessonStatus.completed),
        LessonModel(number: '06', title: 'PPC & Google Ads', duration: '2 hrs', status: LessonStatus.completed),
        LessonModel(number: '07', title: 'Shopify Creation', duration: '2.5 hrs', status: LessonStatus.current),
        LessonModel(number: '08', title: 'Analytics & Tracking', duration: '2 hrs', status: LessonStatus.locked),
        LessonModel(number: '09', title: 'Influencer Marketing', duration: '1.5 hrs', status: LessonStatus.locked),
        LessonModel(number: '10', title: 'Marketing Automation', duration: '2 hrs', status: LessonStatus.locked),
        LessonModel(number: '11', title: 'Brand Strategy', duration: '2 hrs', status: LessonStatus.locked),
        LessonModel(number: '12', title: 'Final Project', duration: '4 hrs', status: LessonStatus.locked),
      ],
    ),
    'Artificial Intelligence': CourseDetailModel(
      name: 'Artificial Intelligence',
      instructor: 'Dr. Ahmed Khan',
      instructorRole: 'Associate Professor',
      totalLessons: 15,
      totalDuration: '36 hrs',
      credits: 4,
      progress: 0.27,
      resources: ['AI Textbook (PDF)', 'Python Notebooks', 'Dataset Collection'],
      lessons: [
        LessonModel(number: '01', title: 'What is Artificial Intelligence?', duration: '1 hr', status: LessonStatus.completed),
        LessonModel(number: '02', title: 'History & Evolution of AI', duration: '1 hr', status: LessonStatus.completed),
        LessonModel(number: '03', title: 'Search Algorithms', duration: '2 hrs', status: LessonStatus.completed),
        LessonModel(number: '04', title: 'Machine Learning Basics', duration: '2.5 hrs', status: LessonStatus.current),
        LessonModel(number: '05', title: 'Neural Networks', duration: '3 hrs', status: LessonStatus.locked),
        LessonModel(number: '06', title: 'Deep Learning', duration: '3 hrs', status: LessonStatus.locked),
        LessonModel(number: '07', title: 'Natural Language Processing', duration: '2.5 hrs', status: LessonStatus.locked),
        LessonModel(number: '08', title: 'Computer Vision', duration: '2.5 hrs', status: LessonStatus.locked),
      ],
    ),
  };

  return courses[courseName] ?? CourseDetailModel(
    name: courseName,
    instructor: 'Staff',
    totalLessons: 10,
    totalDuration: '20 hrs',
    progress: 0.0,
    lessons: List.generate(10, (i) => LessonModel(
      number: (i + 1).toString().padLeft(2, '0'),
      title: 'Lesson ${i + 1}',
      duration: '1.5 hrs',
      status: i == 0 ? LessonStatus.current : LessonStatus.locked,
    )),
  );
}

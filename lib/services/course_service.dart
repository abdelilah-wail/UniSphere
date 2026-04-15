import 'api_service.dart';

class CourseService {
  // ─── Get all courses (optional category filter) ─────
  static Future<List<dynamic>> getCourses({String? category}) async {
    String endpoint = '/courses';
    if (category != null && category.isNotEmpty) {
      endpoint += '?category=$category';
    }
    final response = await ApiService.get(endpoint);
    // The API returns an array, but our ApiService wraps non-map responses
    return response['data'] is List ? response['data'] : [];
  }

  // ─── Get single course detail ─────────────────────
  static Future<Map<String, dynamic>> getCourseById(String id) async {
    return await ApiService.get('/courses/$id');
  }

  // ─── Enroll in a course ───────────────────────────
  static Future<Map<String, dynamic>> enroll(String courseId) async {
    return await ApiService.post('/courses/$courseId/enroll');
  }

  // ─── Unenroll from a course ───────────────────────
  static Future<Map<String, dynamic>> unenroll(String courseId) async {
    return await ApiService.delete('/courses/$courseId/enroll');
  }
}

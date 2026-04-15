import 'api_service.dart';

class NewsService {
  // ─── Get all news (optional limit) ────────────────
  static Future<List<dynamic>> getNews({int? limit}) async {
    String endpoint = '/news';
    if (limit != null) endpoint += '?limit=$limit';
    final response = await ApiService.get(endpoint);
    return response['data'] is List ? response['data'] : [];
  }
}

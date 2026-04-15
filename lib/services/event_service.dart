import 'api_service.dart';

class EventService {
  // ─── Get all events (optional limit) ─────────────
  static Future<List<dynamic>> getEvents({int? limit}) async {
    String endpoint = '/events';
    if (limit != null) endpoint += '?limit=$limit';
    final response = await ApiService.get(endpoint);
    return response['data'] is List ? response['data'] : [];
  }
}

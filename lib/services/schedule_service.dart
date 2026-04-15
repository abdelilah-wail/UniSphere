import 'api_service.dart';

class ScheduleService {
  // ─── Get schedule (optional day filter) ──────────
  static Future<List<dynamic>> getSchedule({String? day}) async {
    String endpoint = '/schedule';
    if (day != null && day.isNotEmpty) {
      endpoint += '?day=$day';
    }
    final response = await ApiService.get(endpoint);
    return response['data'] is List ? response['data'] : [];
  }
}

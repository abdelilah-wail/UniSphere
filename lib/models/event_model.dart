class EventModel {
  final String title;
  final String location;
  final String date;
  final String imageUrl;
  final String description;
  final String? time;
  final String? venue;
  final String? organizer;

  const EventModel({
    required this.title,
    required this.location,
    required this.date,
    required this.imageUrl,
    this.description = '',
    this.time,
    this.venue,
    this.organizer,
  });
}

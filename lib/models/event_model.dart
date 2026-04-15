class EventModel {
  final String id;
  final String title;
  final String location;
  final String date;
  final String? time;
  final String? description;
  final String? imageUrl;
  final String? venue;
  final String? organizer;

  const EventModel({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    this.time,
    this.description,
    this.imageUrl,
    this.venue,
    this.organizer,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      date: json['date'] ?? '',
      time: json['time'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      venue: json['venue'],
      organizer: json['organizer'],
    );
  }
}

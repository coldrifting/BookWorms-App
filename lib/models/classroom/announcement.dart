class Announcement {
  final String announcementId;
  String title;
  String body;
  DateTime time;
  bool isRead;

  Announcement({
    required this.announcementId,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false
  });

  // Decodes the JSON to create a Classroom object.
  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      announcementId: json['announcementId'],
      title: json['title'],
      body: json['body'],
      time: DateTime.parse(json['time']),
      isRead: json['isRead'] ?? false
    );
  }
}
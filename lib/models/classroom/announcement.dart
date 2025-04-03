class Announcement {
  final String announcementId;
  String title;
  String body;
  DateTime time;

  Announcement({
    required this.announcementId,
    required this.title,
    required this.body,
    required this.time
  });

  // Decodes the JSON to create a Classroom object.
  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      announcementId: json['announcementId'],
      title: json['title'],
      body: json['body'],
      time: DateTime.parse(json['time'])
    );
  }
}
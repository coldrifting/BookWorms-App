import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/classroom/announcement.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassAnnouncements extends StatefulWidget {
  const ClassAnnouncements({super.key});

  // ClassAnnouncements

  @override
  State<ClassAnnouncements> createState() => _ClassAnnouncementsState();
}

class _ClassAnnouncementsState extends State<ClassAnnouncements> {
  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    Classroom classroom = appState.classroom!;

    return SingleChildScrollView(
      child: Column(
        children: [
          addVerticalSpace(8),
          Text("Announcements"),

          for (Announcement announcement in classroom.announcements) ...[
            addVerticalSpace(16),
            Text(announcement.title),
          ],
        ],
      ),
    );
  }
}
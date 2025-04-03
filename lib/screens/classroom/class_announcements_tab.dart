import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/classroom/announcement.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ClassAnnouncements extends StatefulWidget {
  const ClassAnnouncements({super.key});

  // ClassAnnouncements

  @override
  State<ClassAnnouncements> createState() => _ClassAnnouncementsState();
}

class _ClassAnnouncementsState extends State<ClassAnnouncements> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);
    Classroom classroom = appState.classroom!;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        children: [
          addVerticalSpace(8),
          for (Announcement announcement in classroom.announcements) ...[
            _announcementListItem(context, textTheme, announcement),
            addVerticalSpace(8)
          ],
        ],
      ),
    );
  }

  Widget _announcementListItem(
      BuildContext context, TextTheme textTheme, Announcement announcement) {
    return Container(
      decoration: BoxDecoration(
        color: colorWhite,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          // TODO
          pushScreen(context, Text("TODO"));
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      announcement.title,
                      style: textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded,
                      size: 24, color: colorGreyDark),
                ],
              ),
              addVerticalSpace(8),
              Text(announcement.body,
                  style: textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis),
              addVerticalSpace(8),
              Text("Posted ${timeago.format(announcement.time.toLocal())}",
                style: textTheme.bodySmall)
            ],
          ),
        ),
      ),
    );
  }
}

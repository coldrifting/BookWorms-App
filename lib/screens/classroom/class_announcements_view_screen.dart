import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/classroom/announcement.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/screens/classroom/class_announcements_edit_screen.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ClassAnnouncementsView extends StatefulWidget {
  final String announcementId;

  const ClassAnnouncementsView(this.announcementId, {super.key});

  // ClassAnnouncements

  @override
  State<ClassAnnouncementsView> createState() => _ClassAnnouncementsViewState();
}

class _ClassAnnouncementsViewState extends State<ClassAnnouncementsView> {
  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);

    Announcement? announcement = appState.classroom?.announcements
        .firstWhere((a) => a.announcementId == widget.announcementId);

    FloatingActionButton? fab = appState.isParent
        ? null
        : floatingActionButtonWithText(
            "Edit Announcement",
            Icons.edit,
            () => pushScreen(context,
                ClassAnnouncementsEditScreen(announcement!)));

    Widget body = announcement == null
        ? Text("Could not load announcement")
        : announcementViewPageBody(announcement);

    return Scaffold(
        appBar: AppBarCustom("Announcement Details"),
        body: body,
        floatingActionButton: fab);
  }
}

Widget announcementViewPageBody(Announcement announcement) {
  return Builder(builder: (context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                addHorizontalSpace(4),
                Text(announcement.title, style: textTheme.headlineSmall),
              ],
            ),
            addVerticalSpace(8),
            Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    color: colorWhite,
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(announcement.body))),
            addVerticalSpace(8),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text("Posted ${timeago.format(announcement.time.toLocal())}"),
              addHorizontalSpace(4)
            ])
          ],
        ));
  });
}

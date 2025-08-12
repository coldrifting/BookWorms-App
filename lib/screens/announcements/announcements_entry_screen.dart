import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/classroom/announcement.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/announcements/announcements_modify_screen.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class AnnouncementsEntryScreen extends StatefulWidget {
  final String announcementId;

  const AnnouncementsEntryScreen(this.announcementId, {super.key});

  // ClassAnnouncements

  @override
  State<AnnouncementsEntryScreen> createState() => _AnnouncementsEntryScreenState();
}

class _AnnouncementsEntryScreenState extends State<AnnouncementsEntryScreen> {
  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);

    Announcement? announcement = (appState.isParent
        ? appState.children[appState.selectedChildID].classrooms.expand((c) => c.announcements)
        : appState.classroom?.announcements)
        ?.where((a) => a.announcementId == widget.announcementId).firstOrNull;

    // Guard against bad state if child changes while viewing an announcement
    if (announcement == null) {
      Navigator.of(context).pop();
      return SizedBox();
    }

    if (appState.isParent) {
      appState.markAnnouncementAsRead(announcement);
    }

    FloatingActionButton? fab = appState.isParent
        ? null
        : floatingActionButtonWithText(
            context,
            "Edit Announcement",
            Icons.edit,
            () => pushScreen(context, AnnouncementsModifyScreen(announcement)));

    return Scaffold(
        appBar: AppBarCustom("Announcement Details"),
        body: announcementViewPageBody(announcement),
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
                    color: context.colors.surface,
                    border: Border.all(color: context.colors.surfaceBorder),
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

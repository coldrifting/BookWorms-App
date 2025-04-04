import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/classroom/announcement.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/screens/announcements/announcements_modify_screen.dart';
import 'package:bookworms_app/screens/announcements/announcements_entry_screen.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class AnnouncementsAllScreen extends StatefulWidget {
  const AnnouncementsAllScreen({super.key});

  @override
  State<AnnouncementsAllScreen> createState() => _AnnouncementsAllScreenState();
}

class _AnnouncementsAllScreenState extends State<AnnouncementsAllScreen> {
  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);

    Map<String, String> announcementToClassNameMap = {};

    List<Announcement> announcements = (appState.isParent
        ? appState.children[appState.selectedChildID].classrooms.expand((a) => a.announcements)
        : appState.classroom!.announcements)
        .sortedBy((a) => a.time).reversed.toList();

    if (appState.isParent) {
      for (var classroom in appState.children[appState.selectedChildID].classrooms) {
        for (var announcement in classroom.announcements) {
          announcementToClassNameMap[announcement.announcementId] = classroom.classroomName;
        }
      }
    }

    SingleChildScrollView body = SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        children: [
          addVerticalSpace(8),
          if (!appState.isParent)...[
            _addClassAnnouncementButton(),
            addVerticalSpace(12),
          ],
          if (announcements.isEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No Announcements Found", style: TextStyle(fontSize: 16))
              ],
            ),
          for (Announcement announcement in announcements) ... [
            if (appState.isParent)
              _announcementListItem(context, announcement, appState.isParent, announcementToClassNameMap)
            else
              _announcementListItemSlidable(context, announcement, appState.deleteAnnouncement),
            addVerticalSpace(8)
          ],
        ],
      ),
    )
    );

    return appState.isParent
        ? Scaffold(appBar: AppBarCustom("All Announcements"), body: body)
        : body;
  }

  Widget _addClassAnnouncementButton() {
    return FractionallySizedBox(
      widthFactor: 0.55,
      child: TextButton(
        onPressed: () => pushScreen(context, AnnouncementsModifyScreen(Announcement(announcementId: "-1", title: "", body: "", time: DateTime.now()))),
        style: TextButton.styleFrom(
          backgroundColor: colorGreen,
          foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Add New Announcement"),
            addHorizontalSpace(8),
            Icon(Icons.announcement, color: colorWhite),
          ],
        ),
      ),
    );
  }

  Widget _announcementListItemSlidable(
      BuildContext context, Announcement announcement, Function(String) deleteAction) {
    return Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
            onDismissed: () async {
              await deleteAction.call(announcement.announcementId);//appState.deleteAnnouncement(announcement.announcementId);
            },
          ),
          children: [
            SlidableAction(
              autoClose: false,
              onPressed: (BuildContext context) async {
                bool result = await showConfirmDialog(
                    context,
                    "Delete Announcement",
                    'Are you sure you wish to delete the announcement'
                        ' titled:\r\n'
                        '${announcement.title}?',
                    confirmText: 'Delete',
                    confirmColor: colorRed);
                if (result) {
                  await deleteAction.call(announcement.announcementId);//appState
                     // .deleteAnnouncement(announcement.announcementId);
                } else {
                  if (context.mounted) {
                    Slidable.of(context)?.close();
                  }
                }
              },
              backgroundColor: colorRed,
              foregroundColor: colorWhite,
              borderRadius: BorderRadius.circular(4),
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: _announcementListItem(context, announcement, false));
  }

  Widget _announcementListItem(BuildContext context, Announcement announcement, bool isParent, [Map<String, String>? announcementToClassNameMap]) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: colorWhite,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => pushScreen(context, AnnouncementsEntryScreen(announcement.announcementId)),
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
              if (announcementToClassNameMap != null)
                Text(announcementToClassNameMap[announcement.announcementId] ?? "",
                style: TextStyle(color: colorGreenDark, fontStyle: FontStyle.italic),),
              addVerticalSpace(8),
              Text(announcement.body,
                  style: textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis),
              addVerticalSpace(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Posted ${timeago.format(announcement.time.toLocal())}",
                      style: textTheme.bodySmall),

                  if (isParent && !announcement.isRead)
                    Text("Unread", style: textTheme.bodySmall!.copyWith(color: colorRed))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

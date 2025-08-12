import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/announcements/announcements_all_screen.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnnouncementsWidget extends StatelessWidget {
  const AnnouncementsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    Child selectedChild = appState.children[appState.selectedChildID];

    bool showAnnouncementBadge = selectedChild.classrooms.expand((c) => c.announcements).any((a) => a.isRead == false);
    return IconButton(
      onPressed: () {
        pushScreen(context, AnnouncementsAllScreen());
      },
      color: context.colors.onPrimary,
      icon: Badge(
        isLabelVisible: showAnnouncementBadge,
        label: null,
        smallSize: 12,
        backgroundColor: context.colors.unread,
        child: const Icon(Icons.notifications),
      )
    );
  }
}
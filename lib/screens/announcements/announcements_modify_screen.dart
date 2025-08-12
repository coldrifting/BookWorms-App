import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/classroom/announcement.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnnouncementsModifyScreen extends StatefulWidget {
  final Announcement announcement;

  const AnnouncementsModifyScreen(this.announcement, {super.key});

  // ClassAnnouncements

  @override
  State<AnnouncementsModifyScreen> createState() =>
      _AnnouncementsModifyScreenState();
}

class _AnnouncementsModifyScreenState
    extends State<AnnouncementsModifyScreen> {

  bool _hasChanges = false;
  bool _isValid = false;

  late String _announcementId;
  late String _initialAnnouncementTitle;
  late String _initialAnnouncementBody;

  late TextEditingController _titleTextController;
  late TextEditingController _bodyTextController;

  // Used to check if a change to the account details has been made.
  void _checkForChanges() {
    setState(() {
      _hasChanges =
          _titleTextController.text.trim() != _initialAnnouncementTitle ||
          _bodyTextController.text.trim() != _initialAnnouncementBody;

      _isValid = _titleTextController.text.trim() != "" && _bodyTextController.text.trim() != "";
    });
  }

  @override
  void initState() {
    super.initState();

    _announcementId = widget.announcement.announcementId;
    _initialAnnouncementTitle = widget.announcement.title;
    _initialAnnouncementBody = widget.announcement.body;

    _titleTextController = TextEditingController(text: _initialAnnouncementTitle);
    _bodyTextController = TextEditingController(text: _initialAnnouncementBody);
  }

  @override
  void dispose() {
    super.dispose();

    _titleTextController.dispose();
    _bodyTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);

    String headerTitle = _announcementId == "-1"
        ? "New Announcement"
        : "Edit Announcement";

    bool isNewAnnouncement = _announcementId == "-1";

    return Scaffold(
        appBar: AppBarCustom(headerTitle,
            onBackBtnPressed: () async => confirmExitWithoutSaving(
                context, Navigator.of(context), _hasChanges)),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 24,
                            child: Column(children: [
                              Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: context.colors.surface,
                                      border:
                                          Border.all(color: context.colors.surfaceBorder),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Title"),
                                        TextField(
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: context.colors.surfaceVariant,
                                                hintStyle: TextStyle(color: context.colors.onSurfaceDim),
                                                hintText: "Announcement Title"),
                                            controller: _titleTextController,
                                            onChanged: (text) => {_checkForChanges()}),
                                      ])),
                              addVerticalSpace(8),
                              Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: context.colors.surface,
                                      border:
                                          Border.all(color: context.colors.surfaceBorder),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Body"),
                                        TextField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: context.colors.surfaceVariant,
                                                hintStyle: TextStyle(color: context.colors.onSurfaceDim),
                                                hintText: "Announcement Body"),
                                            controller: _bodyTextController,
                                            onChanged: (text) => {_checkForChanges()}),
                                      ]))
                            ]))
                        //TextFormField(initialValue: title)
                      ],
                    ),
                    addVerticalSpace(8),
                    ElevatedButton(
                        onPressed: !_isValid || !_hasChanges ? null : () async {
                          var result = isNewAnnouncement
                              ? await appState.addAnnouncement(
                                  _titleTextController.text.trim(),
                                  _bodyTextController.text.trim())
                              : await appState.editAnnouncement(
                                  _announcementId,
                                  _titleTextController.text.trim(),
                                  _bodyTextController.text.trim());

                          resultAlert(context, result);
                        },
                        style: mediumButtonStyle,
                        child: Text(isNewAnnouncement ? "Post Announcement" : "Update Announcement"))
                  ],
                ))));
  }

}

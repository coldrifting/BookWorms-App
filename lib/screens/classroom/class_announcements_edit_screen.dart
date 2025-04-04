import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/classroom/announcement.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassAnnouncementsEditScreen extends StatefulWidget {
  final Announcement announcement;

  const ClassAnnouncementsEditScreen(this.announcement, {super.key});

  // ClassAnnouncements

  @override
  State<ClassAnnouncementsEditScreen> createState() =>
      _ClassAnnouncementsEditScreenState();
}

class _ClassAnnouncementsEditScreenState
    extends State<ClassAnnouncementsEditScreen> {

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
                                      color: colorWhite,
                                      border:
                                          Border.all(color: Colors.grey[300]!),
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
                                                fillColor: Color(0xFFF7F7F7),
                                                hintText: "Announcement Title"),
                                            controller: _titleTextController,
                                            onChanged: (text) => {_checkForChanges()}),
                                      ])),
                              addVerticalSpace(8),
                              Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: colorWhite,
                                      border:
                                          Border.all(color: Colors.grey[300]!),
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
                                                fillColor: Color(0xFFF7F7F7),
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
                        onPressed: !_isValid ? null : () async {
                          var result = isNewAnnouncement
                              ? await appState.addAnnouncement(
                                  _titleTextController.text.trim(),
                                  _bodyTextController.text.trim())
                              : await appState.editAnnouncement(
                                  _announcementId,
                                  _titleTextController.text.trim(),
                                  _bodyTextController.text.trim());
                          if (result && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: colorGreenDark,
                                content: Row(
                                  children: [
                                    Text(isNewAnnouncement
                                        ? "Successfully Added Announcement"
                                        : "Successfully Updated Announcement"),
                                    Spacer(),
                                    Icon(Icons.check, color: colorWhite)
                                  ],
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );

                            Navigator.of(context).pop();
                            if (!isNewAnnouncement) {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 38),
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            iconSize: 26,
                            foregroundColor: colorWhite,
                            backgroundColor: colorGreen),
                        child: Text(isNewAnnouncement ? "Post Announcement" : "Update Announcement"))
                  ],
                ))));
  }

}

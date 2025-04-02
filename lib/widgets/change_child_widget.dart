import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/utils/user_icons.dart';

class ChangeChildWidget extends StatefulWidget {
  final Function()? onChildChanged;

  const ChangeChildWidget({super.key, this.onChildChanged});

  @override
  State<ChangeChildWidget> createState() => _ChangeChildWidgetState();
}

class _ChangeChildWidgetState extends State<ChangeChildWidget> {
  @override
  Widget build(BuildContext context) {

    int selectedChildID = Provider.of<AppState>(context).selectedChildID;
    Child selectedChild = Provider.of<AppState>(context).children[selectedChildID];
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          _showChildSelection(selectedChild);
        },
        child: CircleAvatar(
          child: SizedBox.expand(
            child: FittedBox(
              child: UserIcons.getIcon(selectedChild.profilePictureIndex)
            ),
          ),
        ),
      ),
    );
  }

  void _showChildSelection(Child selectedChild) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Switch Profiles",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              addVerticalSpace(16),
              Expanded (
                child: ListView.builder(
                  itemCount: Provider.of<AppState>(context).children.length,
                  itemBuilder: (context, index) {
                    Child child = Provider.of<AppState>(context).children[index];
                    return Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: UserIcons.getIcon(child.profilePictureIndex)
                      ),
                      title: Text(child.name, style: TextStyle(fontSize: 17.0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      selectedTileColor: colorGreen,
                      textColor: colorGreenDark,
                      selectedColor: colorWhite,
                      onTap: () {
                        Provider.of<AppState>(context, listen: false).setSelectedChild(index);
                        Navigator.pop(context);

                        // Function to be called when changing the selected child.
                        if (widget.onChildChanged != null) {
                          widget.onChildChanged!();
                        }
                      },
                      selected: index == Provider.of<AppState>(context).selectedChildID,
                    )
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChildSelectionListWidget extends StatelessWidget {
  final VoidCallback? onChildChanged;

  const ChildSelectionListWidget({super.key, this.onChildChanged});

  @override
  Widget build(BuildContext context) {
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
                return Column(
                    children: [
                      ListTile(
                  leading: CircleAvatar(
                    child: UserIcons.getIcon(child.profilePictureIndex)
                  ),
                  title: Text(child.name),
                  selectedColor: colorWhite,
                  selectedTileColor: colorGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () {
                    Provider.of<AppState>(context, listen: false).setSelectedChild(index);
                    Navigator.pop(context);

                    // Function to be called when changing the selected child.
                    if (onChildChanged != null) {
                      onChildChanged!();
                    }
                  },
                  selected: index == Provider.of<AppState>(context).selectedChildID,
                ),
                    addVerticalSpace(6)]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
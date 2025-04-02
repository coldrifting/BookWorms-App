import 'package:bookworms_app/widgets/child_selection_list_widget.dart';
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
        onTap: () => showChildSelection(selectedChild),
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

  void showChildSelection(Child selectedChild) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ChildSelectionListWidget(onChildChanged: widget.onChildChanged);
      },
    );
  }
}
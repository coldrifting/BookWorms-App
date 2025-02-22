import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
              const SizedBox(height: 16),
              Expanded (
                child: ListView.builder(
                  itemCount: Provider.of<AppState>(context).children.length,
                  itemBuilder: (context, index) {
                    Child child = Provider.of<AppState>(context).children[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: UserIcons.getIcon(child.profilePictureIndex)
                      ),
                      title: Text(child.name),
                      onTap: () {
                        Provider.of<AppState>(context, listen: false).setSelectedChild(index);
                        Navigator.pop(context);

                        // Function to be called when changing the selected child.
                        if (widget.onChildChanged != null) {
                          widget.onChildChanged!();
                        }
                      },
                      selected: index == Provider.of<AppState>(context).selectedChildID,
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
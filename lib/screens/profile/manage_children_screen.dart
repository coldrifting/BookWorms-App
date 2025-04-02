import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/screens/profile/edit_child_screen.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/utils/widget_functions.dart';

class ManageChildrenScreen extends StatefulWidget {
  const ManageChildrenScreen({super.key});

  @override
  State<ManageChildrenScreen> createState() => _ManageChildrenScreenState();
}

class _ManageChildrenScreenState extends State<ManageChildrenScreen> {
  @override
  Widget build(BuildContext context) {
    List<Child> children = Provider.of<AppState>(context).children;
    
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: const Text(
          "Manage Children", 
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: colorWhite, 
            overflow: TextOverflow.ellipsis
          )
        ),
        backgroundColor: colorGreen,
        leading: IconButton(
          color: colorWhite,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          foregroundColor: colorWhite,
          backgroundColor: colorGreen,
          icon: const Icon(Icons.add),
          label: Text("Add Child"),
          onPressed: () {
            _addChildDialog(context);
          }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
          child: Text(
            "Tap to Edit Child Details",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),
          )),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: children.length,
              itemBuilder: (context, index) {
                return _childWidget(index, children[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _childWidget(int childID, Child child) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () {
            pushScreen(context, EditChildScreen(childID: childID, child: child));
          },
          icon: CircleAvatar(
            maxRadius: 64,
            child: SizedBox.expand(
              child: FittedBox(
                child: UserIcons.getIcon(Provider.of<AppState>(context).children[childID].profilePictureIndex)
              ),
            ),
          ),
        ),
        Text(
          child.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _addChildDialog(BuildContext context) {
    TextEditingController childNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Child"),
        content: TextField(
          controller: childNameController,
          decoration: const InputDecoration(hintText: "Child's Name"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: colorGrey))),
          TextButton(
            onPressed: () {
              String childName = childNameController.text.isNotEmpty
                ? childNameController.text
                : "New Child";
              Provider.of<AppState>(context, listen: false).addChild(childName);
              Navigator.of(context).pop();
            },
            child: const Text("Add")
          ),
        ],
      ),
    );
  }

}
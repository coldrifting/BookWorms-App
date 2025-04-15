import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/screens/profile/edit_child_screen.dart';
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
      appBar: AppBarCustom("Manage Children"),
      floatingActionButton: floatingActionButtonWithText(
          context,
          "Add Child",
          Icons.add, () async {
            String? newChildName = await showTextEntryDialog(
                context,
                "Add New Child",
                "New Child's Name");
            if (newChildName != null && context.mounted) {
              Provider.of<AppState>(context, listen: false).addChild(newChildName);
            }
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
          onPressed: () => pushScreen(context, EditChildScreen(childID: childID, child: child)),
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
}
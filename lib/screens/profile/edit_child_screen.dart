import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/utils/widget_functions.dart';

class EditChildScreen extends StatefulWidget {
  final int childID;
  final Child child;

  const EditChildScreen({
    super.key,
    required this.childID,
    required this.child,
  });

  @override
  State<EditChildScreen> createState() => _EditChildScreenState();
}

class _EditChildScreenState extends State<EditChildScreen> {
  late TextEditingController _childNameController;
  late int _selectedIconIndex;

  @override
  void initState() {
    super.initState();
    _childNameController = TextEditingController(text: widget.child.name);
    _selectedIconIndex = widget.child.profilePictureIndex;
  }

  @override
  void dispose() {
    _childNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: const Text(
          "Edit Child", 
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    IconButton(
                      onPressed: () =>_changeChildIconDialog(textTheme),
                      icon: CircleAvatar(
                        maxRadius: 50,
                        child: SizedBox.expand(
                          child: FittedBox(
                            child: UserIcons.getIcon(widget.child.profilePictureIndex),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      left: 70,
                      child: RawMaterialButton(
                        onPressed: () => _changeChildIconDialog(textTheme),
                        fillColor: colorWhite,
                        constraints: const BoxConstraints(minWidth: 0.0),
                        padding: const EdgeInsets.all(5.0),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.mode_edit_outline_sharp,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Edit Name",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _childNameController
                            )
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              Provider.of<AppState>(context, listen: false).editChildName(widget.childID, _childNameController.text);
                            },
                            child: const Text("Save")
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<AppState>(context, listen: false).removeChild(widget.childID);
                Navigator.of(context).pop();
              },
              child: const Text("Delete Child")
            )
          ],
        ),
      ),
    );
  }

   /// Dialog to change the class icon to a specific color.
  Future<dynamic> _changeChildIconDialog(TextTheme textTheme) {
    return showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
          title: const Center(child: Text('Change Child Icon')),
          content: _getIconList(),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(
                'Cancel',
                style: textTheme.titleSmall
              ),
            ),
          ],
        ),
    );
  }

  Widget _getIconList() {
    return SizedBox(
        width: double.maxFinite,
        height: 400,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Change selected color and exit popup.
                setState(() {
                  _selectedIconIndex = index;
                  Provider.of<AppState>(context, listen: false).setChildIconIndex(widget.childID, _selectedIconIndex);
                });
                Navigator.of(context).pop();
              },
              child: Material(
                shape: CircleBorder(
                  side: BorderSide(
                    color: _selectedIconIndex == index ? Colors.grey[400]! : Colors.grey[300]!,
                  ),
                ),
                shadowColor: _selectedIconIndex == index ? Colors.black : Colors.transparent,
                elevation: _selectedIconIndex == index ? 4 : 2,
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: SizedBox.expand(
                    child: FittedBox(
                      child: UserIcons.getIcon(index)
                    )
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}
import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/child.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: CircleAvatar(
                    maxRadius: 64,
                    child: Text(
                      widget.child.name[0],
                    ),
                  ),
                ),
                const Column(
                  children: [
                    Text("Edit Name"),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<AppState>(context, listen: false).removeChild(widget.childID);
                Navigator.of(context).pop();
              },
              child: const Text("Delete Child"))
          ],
        ),
      ),
    );
  }
}
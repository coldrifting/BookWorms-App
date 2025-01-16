import 'package:bookworms_app/theme/colors.dart';
import 'package:flutter/material.dart';

class EditChildScreen extends StatefulWidget {
  final int childId;
  const EditChildScreen({
    super.key,
    required this.childId,
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
    );
  }
}
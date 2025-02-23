import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:flutter/material.dart';

import 'package:bookworms_app/screens/classroom/classroom_screen.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:provider/provider.dart';

class CreateClassroomScreen extends StatefulWidget {
  const CreateClassroomScreen({super.key});

  @override
  State<CreateClassroomScreen> createState() => _CreateClassroomScreenState();
}

class _CreateClassroomScreenState extends State<CreateClassroomScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: const Text("Create a Classroom",
            style: TextStyle(color: colorWhite)),
        backgroundColor: colorGreen,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Create a Classroom",
                  style: textTheme.headlineSmall,
                ),
              ),
              addVerticalSpace(16),
              TextFormField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter classroom name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a classroom name';
                  }
                  return null;
                },
              ),
              addVerticalSpace(16),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final classroomName = _textEditingController.text;
                    Classroom classroom = await appState.createNewClassroom(classroomName);

                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ClassroomScreen(classroom: classroom)),
                      );
                    }
                  }
                },
                child: const Text('CREATE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

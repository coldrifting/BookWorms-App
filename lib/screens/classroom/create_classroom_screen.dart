import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/showcase/showcase_controller.dart';
import 'package:bookworms_app/showcase/showcase_widgets.dart';
import 'package:flutter/material.dart';
import 'package:bookworms_app/screens/classroom/classroom_screen.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class CreateClassroomScreen extends StatefulWidget {
  const CreateClassroomScreen({super.key});

  @override
  State<CreateClassroomScreen> createState() => _CreateClassroomScreenState();
}

class _CreateClassroomScreenState extends State<CreateClassroomScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final showcaseController = ShowcaseController();
  late final List<GlobalKey> navKeys = showcaseController.getKeysForScreen('classroom');

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context, listen: true);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BWShowcase(
                showcaseKey: navKeys[0],
                title: "Start an amazing classroom here!",
                description:
                "Classrooms have many exciting features. "
                    "You can create class lists, set class goals and reading assignments, "
                    "and even send notifications to parents of students in your class.\n"
                    "Create one after the tutorial to get started!",
                targetPadding: EdgeInsets.all(16),
                tooltipPosition: TooltipPosition.top,
                child: Column(
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
                          await appState.createNewClassroom(classroomName);

                            if (context.mounted) {
                              pushScreen(context, ClassroomScreen(), replace: true);
                            }
                          }
                        },
                        child: const Text('CREATE'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

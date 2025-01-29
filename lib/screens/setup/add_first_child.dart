import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/main.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/setup_backdrop_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFirstChild extends StatefulWidget {
  const AddFirstChild({super.key});

  @override
  State<AddFirstChild> createState() => _AddFirstChildState();
}

class _AddFirstChildState extends State<AddFirstChild> {
  late TextEditingController _childNameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _childNameController = TextEditingController();
  }

  @override
  void dispose() {
    _childNameController.dispose();
    super.dispose();
  }

  void addChild(String childName) async {
    await Provider.of<AppState>(context, listen: false).addChild(childName);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Navigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SetupBackdropWidget(childWidget: _addChildWidget(textTheme))),
    );
  }

  Widget _addChildWidget(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Add a Child",
            style: textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          addVerticalSpace(16),
          Text(
            "Create your first child profile to begin. You can add and manage profiles anytime through the settings menu.",
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          addVerticalSpace(48),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _childNameController,
                decoration: const InputDecoration(labelText: "Child's Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
            ),
          ),
          addVerticalSpace(32),
          FractionallySizedBox(
            widthFactor: 1,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final childName = _childNameController.text;
                  addChild(childName);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: colorGreen,
                foregroundColor: colorWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text("Save and Continue"),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:bookworms_app/main.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/widgets/alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
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
  late ScrollController _scrollController;
  late TextEditingController _childNameController;
  late int _selectedIconIndex;

  final _formKey = GlobalKey<FormState>();

  // Used to determine if any changes have been made to the account details.
  late String _initialName;
  late int _initialIconIndex;
  late bool _hasChanges;

  @override
  void initState() {
    super.initState();

    _initialName = widget.child.name;
    _initialIconIndex = widget.child.profilePictureIndex;
    _selectedIconIndex = widget.child.profilePictureIndex;

    _childNameController = TextEditingController(text: widget.child.name);
    _childNameController.addListener(_checkForChanges);
    _scrollController = ScrollController();

    _hasChanges = false;
  }

  @override
  void dispose() {
    _childNameController.dispose();
    super.dispose();
  }

  // Used to check if a change to the account details has been made.
  void _checkForChanges() {
    setState(() {
      _hasChanges = _childNameController.text.trim() != _initialName 
        || _selectedIconIndex != _initialIconIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context, listen: false);
    Child child = appState.children[appState.selectedChildID];

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
            // Notify the user if there are unsaved changes.
            if (_hasChanges) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertWidget(
                    title: "Unsaved Changes", 
                    message: "Are you sure you want to continue?", 
                    confirmText: "Discard Changes", 
                    confirmColor: colorRed!,
                    cancelText: "Keep Editing", 
                    action: () {
                      if (mounted) {
                        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Navigation(initialIndex: 4)),
                          (route) => false,
                        );
                      }
                    }
                  );
                }
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                              child: UserIcons.getIcon(_selectedIconIndex),
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
                          child: const Icon(Icons.mode_edit_outline_sharp, size: 15),
                        ),
                      ),
                    ],
                  ),
                  addHorizontalSpace(16),
                  Expanded(child: _textFieldWidget(textTheme, _childNameController, "Edit Name")),
                ],
              ),
              addVerticalSpace(16),
              Text("Reading Level: ${child.readingLevel ?? "N/A"}", style: textTheme.titleMedium),
              addVerticalSpace(16),
              _classroomList(textTheme),
              addVerticalSpace(32),  
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 0),
                      backgroundColor: _hasChanges ? colorGreen : colorGreyLight, 
                      foregroundColor: _hasChanges ? colorWhite : colorBlack, 
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: _hasChanges
                      ? () {
                        if (_formKey.currentState?.validate() ?? false) {
                          setState(() {
                            _hasChanges = false;
                            appState.editChildProfileInfo(
                              widget.childID, 
                              newName: _childNameController.text, 
                              profilePictureIndex: _selectedIconIndex
                            );
                            _initialIconIndex = appState.children[widget.childID].profilePictureIndex;
                            _initialName = appState.children[widget.childID].name;
                          });
                        }
                      } : null,
                    child: Text(
                      'Save',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  _deleteChildButton(textTheme),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _classroomList(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context);
    Child child = appState.children[widget.childID];
    List<Classroom> classrooms = child.classrooms;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Manage Classrooms", style: textTheme.titleLarge),
          ],
        ),
        addVerticalSpace(8),
        Container(
          height: 175, 
          decoration: BoxDecoration(
            color: colorGreyLight,
            border: Border.all(color: colorGreyDark ?? colorBlack),
            borderRadius: BorderRadius.circular(6),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            itemCount: classrooms.length + 1,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: index == classrooms.length 
                ? SizedBox(
                  width: 100,
                  child: GestureDetector(
                    onTap: () {
                      _joinClassDialog(textTheme);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: colorGreyDark!, width: 1.5),
                          ),
                          child: CircleAvatar(
                            maxRadius: 45, 
                            backgroundColor: colorGreyLight,
                            child: Icon(size: 40, Icons.add, color: colorGreyDark!),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Join Class",
                              style: textTheme.titleSmall, 
                              maxLines: 2, 
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // TODO
                        },
                        onLongPress: (){

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: colorGreyDark!, width: 1.5),
                          ),
                          child: CircleAvatar(
                            backgroundColor: colorWhite,
                            maxRadius: 45, 
                            child: Icon(
                              size: 50, 
                              Icons.school,
                              color: classroomColors[classrooms[index].classIcon]
                            ),
                          ),
                        ),
                      ),
                      addVerticalSpace(4),
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            classrooms[index].classroomName,
                            style: textTheme.titleSmall, 
                            maxLines: 2, 
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
        ),
      ],
    );
  }

  dynamic _joinClassDialog(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    TextEditingController textEditingController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Center(
            child: Column(
              children: [
                Icon(Icons.school, color: colorGreen!, size: 36),
                Text(
                  'Join Class',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: colorGreen),
                ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Enter your 6-digit classroom code:"),
                addVerticalSpace(8),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: textEditingController,
                  keyboardType: TextInputType.text,
                  animationType: AnimationType.fade,
                  enableActiveFill: false,
                  autoFocus: true,
                  cursorColor: colorGreen,
                  pastedTextStyle: TextStyle(color: colorGreenDark, fontWeight: FontWeight.bold),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 40,
                    fieldWidth: 35,
                    inactiveColor: colorGreenGradTop,
                    activeColor: colorGreen,
                    selectedColor: colorGreen,
                  ),
                ),
                Text("Need help? Ask your teacher!")
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: colorGrey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () async {
                bool success = await appState.joinChildClassroom(widget.childID, textEditingController.text);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: success ? colorGreenDark : colorRed,
                      content: Row(
                        children: [
                          Text(
                            success ? 'Successfully joined class!' : 'An error occurred. Try again!', 
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Icon(
                            success ? Icons.check_circle_outline_rounded : Icons.error_outline, 
                            color: Colors.white
                          )
                        ],
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text("Join", style: TextStyle(color: colorWhite)),
            ),
          ],
        );
      }
    );
  }

  // Text form field input and title.
  Widget _textFieldWidget(TextTheme textTheme, TextEditingController controller, String title) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(title, style: textTheme.titleMedium),
        ),
        TextFormField(
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a value';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _deleteChildButton(TextTheme textTheme) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorRed,
        foregroundColor: colorWhite,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) { 
          return AlertWidget(
            title: "Delete Child Profile", 
            message: "Are you sure you want to delete the child profile of ${widget.child.name}?", 
            confirmText: "Delete", 
            confirmColor: colorRed!,
            cancelText: "Cancel", 
            action: () { Provider.of<AppState>(context, listen: false).removeChild(widget.childID); }
          );
        }
      ),
      child: Text(
        'Delete Child',
        style: textTheme.titleSmallWhite,
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
                  _checkForChanges();
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
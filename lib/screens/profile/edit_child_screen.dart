import 'package:bookworms_app/models/Result.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:bookworms_app/widgets/reading_level_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final _formKey = GlobalKey<FormState>();

  // Used to determine if any changes have been made to the account details.
  late String _initialName;
  late int _initialIconIndex;
  late String? _initialDOB;
  late bool _hasChanges;

  late TextEditingController _childNameController;
  late int _selectedIconIndex;
  late String? _selectedDOB;

  @override
  void initState() {
    super.initState();

    _initialName = widget.child.name;
    _initialIconIndex = widget.child.profilePictureIndex;
    _initialDOB = widget.child.dob;
    _hasChanges = false;

    _childNameController = TextEditingController(text: widget.child.name);
    _childNameController.addListener(_checkForChanges);
    _selectedIconIndex = widget.child.profilePictureIndex;
    _selectedDOB = widget.child.dob;
  }

  @override
  void dispose() {
    _childNameController.dispose();
    super.dispose();
  }

  // Used to check if a change to the account details has been made.
  void _checkForChanges() {
    setState(() {
      _hasChanges = _childNameController.text.trim() != _initialName ||
          _selectedIconIndex != _initialIconIndex ||
          _selectedDOB != _initialDOB;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      appBar: AppBarCustom("Edit Child", onBackBtnPressed: () async =>
          confirmExitWithoutSaving(context, Navigator.of(context), _hasChanges)),
      body: SingleChildScrollView(
    child: Padding(
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
                        onPressed: () => _changeChildIconDialog(textTheme),
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
                  Expanded(
                    child: _textFieldWidget(textTheme, _childNameController, "Edit Name")
                  ),
                ],
              ),
              addVerticalSpace(16),
              Row(
                children: [
                  Text("Reading Level: ${widget.child.readingLevel ?? "N/A"}", style: textTheme.titleMedium),
                  RawMaterialButton(
                    onPressed: () => pushScreen(context, const ReadingLevelInfoWidget()),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8.0),
                    constraints: BoxConstraints(
                      maxWidth: 40,
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      color: colorBlack,
                      size: 20
                    )
                  ),
                ],
              ),
              addVerticalSpace(16),
              Row(
                children: [
                  Text("Date of Birth:", style: textTheme.titleMedium),
                  addHorizontalSpace(16),
                  OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              primaryColor: colorGreen,
                              textButtonTheme: TextButtonThemeData(
                                style: getCommonButtonStyle(primaryColor: colorGreen, isElevated: false)
                              )
                            ),
                            child: child!
                          );
                        },
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDOB = DateFormat('yyyy-MM-dd').format(pickedDate);
                          _checkForChanges();
                        });
                      }
                    },
                    child: Text(_selectedDOB ?? "Set Date", style: textTheme.titleMedium),
                  )
                ],
              ),
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
                                profilePictureIndex: _selectedIconIndex,
                                newDOB: _selectedDOB
                            );
                            _initialIconIndex =
                                appState.children[widget.childID]
                                    .profilePictureIndex;
                            _initialName =
                                appState.children[widget.childID].name;
                          });
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: colorGreenDark,
                                content: Row(
                                  children: [
                                    Text(
                                      'Child Details Updated',
                                      style: TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    Icon(
                                        Icons.check_circle_outline_rounded,
                                        color: Colors.white
                                    )
                                  ],
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                          Navigator.of(context).pop();
                        }
                        } : null,
                    child: Text(
                      'Save Changes',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                _deleteChildButton(textTheme, Navigator.of(context)),
              ]),
            ],
          ),
        ),
      ),
      )
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
            border: Border.all(color: colorGreyDark),
            borderRadius: BorderRadius.circular(6),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
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
                            border: Border.all(color: colorGreyDark, width: 1.5),
                          ),
                          child: CircleAvatar(
                            maxRadius: 45, 
                            backgroundColor: colorGreyLight,
                            child: Icon(size: 40, Icons.add, color: colorGreyDark),
                          ),
                        ),
                        addVerticalSpace(8),
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
                            border: Border.all(color: colorGreyDark, width: 1.5),
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
                      addVerticalSpace(8),
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
        builder: (BuildContext context)
    {
      String input = "";

      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Center(
            child: Column(
              children: [
                Icon(Icons.school, color: colorGreen, size: 36),
                Text(
                  'Join Class',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: colorGreen),
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
                  onChanged: (value) {
                    setState(() => input = value);
                  },
                ),
                Text("Need help? Ask your teacher!")
              ],
            ),
          ),
          actions: [
            dialogButton(
                "Cancel",
                () => Navigator.of(context).pop(),
                foregroundColor: colorGreyDark,
                isElevated: false),
            dialogButton(
                "Join",
                input.length != 6 ? null : () async {
                Result result = await appState.joinChildClassroom(
                    widget.childID, input);
                if (context.mounted) {
                  resultAlert(context, result);
                }
              })
          ],
        );
      });
    });
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

  Widget _deleteChildButton(TextTheme textTheme, NavigatorState navState) {
    AppState appState = Provider.of<AppState>(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorRed,
        foregroundColor: colorWhite,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
        onPressed: () async {
          if (Provider
              .of<AppState>(context, listen: false)
              .children
              .length > 1) {
            bool result = await showConfirmDialog(
                context,
                "Delete Child Profile",
                "Are you sure you want to delete the child profile of ${widget
                    .child.name}?",
                confirmText: "Delete",
                confirmColor: colorRed);

            if (result && mounted) {
              Provider.of<AppState>(context, listen: false).removeChild(
                  widget.child.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: colorRed,
                  content: Row(
                    children: [
                      Text('Removed ${widget.child.name} from children',
                          style: textTheme.titleSmallWhite),
                      Spacer(),
                      Icon(Icons.close_rounded, color: colorWhite)
                    ],
                  ),
                  duration: Duration(seconds: 2),
            ),
          );
          navState.pop(true);
        }
        }
        else {
          await showConfirmDialog(context,
              "Delete Child Profile",
              'You cannot delete all child profiles from your account.',
              confirmText: "OK");
        }
      },
      child: Text('Delete Child', style: textTheme.titleSmallWhite),
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
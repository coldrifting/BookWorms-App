import 'package:bookworms_app/widgets/alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/main.dart';
import 'package:bookworms_app/models/account/account.dart';
import 'package:bookworms_app/screens/setup/welcome_screen.dart';
import 'package:bookworms_app/services/account/delete_account_service.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/utils/widget_functions.dart';

class EditProfileScreen extends StatefulWidget {

  final Account account;

  const EditProfileScreen({
    super.key,
    required this.account,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  final _formKey = GlobalKey<FormState>();

  late int _selectedIconIndex;

  // Used to determine if any changes have been made to the account details.
  late String _initialFirstName;
  late String _initialLastName;
  late int _initialIconIndex;
  late bool _hasChanges;

  @override
  void initState() {
    super.initState();

    _initialFirstName = widget.account.firstName;
    _initialLastName = widget.account.lastName;
    _initialIconIndex = widget.account.profilePictureIndex;

    _firstNameController = TextEditingController(text: _initialFirstName);
    _firstNameController.addListener(_checkForChanges);
    _lastNameController = TextEditingController(text: _initialLastName);
    _lastNameController.addListener(_checkForChanges);

    _selectedIconIndex = _initialIconIndex;
    _hasChanges = false;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  
  // Used to check if a change to the account details has been made.
  void _checkForChanges() {
    setState(() {
      _hasChanges = _firstNameController.text.trim() != _initialFirstName 
        || _lastNameController.text.trim() != _initialLastName
        || _selectedIconIndex != _initialIconIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context, listen: false);
    bool isParent = appState.isParent;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: const Text(
          "Edit Profile", 
          style: TextStyle(
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
                          MaterialPageRoute(builder: (context) => Navigation(initialIndex: isParent ? 4 : 3)),
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
            children: [
              _profileIcon(textTheme),
              addVerticalSpace(16),
              _textFieldWidget(
                textTheme, 
                _firstNameController, 
                "Edit First Name", 
              ),
              addVerticalSpace(32),
              _textFieldWidget(
                textTheme, 
                _lastNameController, 
                "Edit Last Name", 
              ),
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
                          appState.editAccountInfo(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            profilePictureIndex: _selectedIconIndex
                          );
                          setState(() {
                            _hasChanges = false;
                            _initialFirstName = _firstNameController.text;
                            _initialLastName = _lastNameController.text;
                            _initialIconIndex = _selectedIconIndex;
                          });
                        }
                      } : null,
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
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
                          title: "Delete Account", 
                          message: "Deleting your account cannot be undone. Are you sure you want to continue?", 
                          confirmText: "Delete", 
                          confirmColor: colorRed!,
                          cancelText: "Cancel", 
                          action: _deleteAccount
                        );
                      }
                    ),
                    child: Text('Delete Account', style: textTheme.titleSmallWhite),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Deletes the user's account and navigates to homescreen.
  Future<void> _deleteAccount() async {
    AppState appState = Provider.of<AppState>(context, listen: false);

    DeleteAccountService deleteAccountService = DeleteAccountService();
    var status = await deleteAccountService.deleteAccount(appState.username);

    if (status) {
      // Clear navigation stack and navigate to the welcome screen.
      if (mounted) {
        pushScreen(context, const WelcomeScreen(), root: true, replace: true);
      }
    }
  }

  // The account profile icon along with modification functionality.
  Widget _profileIcon(TextTheme textTheme) {
    return Center(
      child: Stack(
        children: [
          IconButton(
            onPressed: () => changeIconDialog(textTheme),
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
              onPressed: () => changeIconDialog(textTheme),
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

  // Dialog to change the profile icon to a specific color.
  Future<dynamic> changeIconDialog(TextTheme textTheme) {
    return showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
          title: const Center(child: Text('Change Profile Icon')),
          content: _getIconList(),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text('Cancel', style: textTheme.titleSmall),
            ),
          ],
        ),
    );
  }

  // Displays the icon list for the account.
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


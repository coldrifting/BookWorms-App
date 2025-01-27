import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/account.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {

  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;

  final _formKey = GlobalKey<FormState>();

  late int _selectedIconIndex;

  @override
  void initState() {
    super.initState();
    AppState appState =  Provider.of<AppState>(context);
    _firstNameController = TextEditingController(text: appState.firstName);
    _lastNameController = TextEditingController(text: appState.lastName);
    _usernameController = TextEditingController(text: appState.username);
    _selectedIconIndex = 0;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile", 
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _profileIcon(textTheme),
              addHorizontalSpace(16),
              _textFieldWidget(
                textTheme, 
                _firstNameController, 
                "Edit First Name", 
                appState.firstName, 
                appState.editFirstName
              ),
              addVerticalSpace(32),
              _textFieldWidget(
                textTheme, 
                _lastNameController, 
                "Edit Last Name", 
                appState.lastName,
                appState.editLastName
              ),
              addVerticalSpace(32),
              _textFieldWidget(
                  textTheme, 
                _usernameController, 
                "Change username", 
                appState.username,
                appState.editUsername
              ),
            ],
          ),
        ),
      ),
    );
  }

  // The account profile icon along with modification functionality.
  Widget _profileIcon(TextTheme textTheme) {
    return Center(
      child: Stack(
        children: [
          IconButton(
            onPressed: () =>changeIconDialog(textTheme),
            icon: CircleAvatar(
              maxRadius: 50,
              child: SizedBox.expand(
                child: FittedBox(
                  child: UserIcons.getIcon(0),
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

  // Text form field input, title, and save.
  Widget _textFieldWidget(
    TextTheme textTheme, 
    TextEditingController controller, 
    String title, 
    String text,
    Function onSave) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: textTheme.titleMedium,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              )
            ),
            addHorizontalSpace(16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  onSave(controller.text);
                }
              },
              child: const Text("Save")
            )
          ],
        ),
      ],
    );
  }

   /// Dialog to change the class icon to a specific color.
  Future<dynamic> changeIconDialog(TextTheme textTheme) {
    return showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
          title: const Center(child: Text('Change Profile Icon')),
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

  /// Displays the icon list for the account.
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


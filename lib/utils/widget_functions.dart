import 'package:bookworms_app/models/action_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bookworms_app/resources/colors.dart';

// Creates a SizedBox widget with specified height.
Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

// Creates a SizedBox widget with specified width.
Widget addHorizontalSpace(double width) {
  return SizedBox(width: width);
}

Future<bool> showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    {String confirmText = "Confirm",
    String cancelText = "Cancel",
    Color confirmColor = colorGreen,
    Color cancelColor = colorGreyDark,
    bool showCancelButton = true}) async {
  var result = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        var confirmButton =
              dialogButton(
                  confirmText,
                  () => Navigator.of(context, rootNavigator: true).pop(true),
                  foregroundColor: colorWhite,
                  backgroundColor: confirmColor);

        var cancelButton = dialogButton(
                  cancelText,
                  () => Navigator.of(context, rootNavigator: true).pop(false),
                  foregroundColor: cancelColor,
                  isElevated: false);

        return AlertDialog(
          title: Center(child: Text(title, textAlign: TextAlign.center)),
          content: Text(message, textAlign: TextAlign.center),
          actions: showCancelButton ? [cancelButton, confirmButton] : [confirmButton]
        );
      });

  return result == true;
}

// Null for cancel
Future<String?> showTextEntryDialog(
    BuildContext context, String title, String hint,
    {String confirmText = "Confirm",
    String cancelText = "Cancel",
    Color confirmColor = colorGreen}) async {
  var result = await showDialog<String>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        String input = "";
        TextEditingController textEditingController = TextEditingController();
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              autofocus: true,
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: hint,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => input = value);
              },
            ),
            actions: [
              dialogButton(
                  cancelText,
                  () => Navigator.of(context, rootNavigator: true).pop(null),
                  foregroundColor: colorGreyDark,
                  isElevated: false),
              dialogButton(
                  confirmText,
                  input.isEmpty ? null : () => Navigator.of(context, rootNavigator: true).pop(input),
                  foregroundColor: colorWhite,
                  backgroundColor: confirmColor),
            ],
          );
        });
      });

  return result;
}

void confirmExitWithoutSaving(
    BuildContext context,
    NavigatorState navState,
    bool hasChanges) async {
  if (hasChanges) {
    bool result = await showConfirmDialog(
        context,
        "Unsaved Changes",
        "Are you sure you want to continue?",
        confirmText: "Discard Changes",
        confirmColor: colorRed);
    if (result) {
      navState.pop();
    }
  } else {
    navState.pop();
  }
}

Widget dialogButton(String label, Function()? onPressed,
    {Color foregroundColor = colorWhite,
    Color backgroundColor = colorGreen,
    bool isElevated = true}) {
  var text = Text(label);

  if (isElevated) {
    return ElevatedButton(
        onPressed: onPressed,
        style: getCommonButtonStyle(
            primaryColor: onPressed != null ? backgroundColor : colorGreyDark,
            secondaryColor: onPressed != null ? foregroundColor : colorWhite),
        child: text);
  }
  return TextButton(
      onPressed: onPressed,
      style: getCommonButtonStyle(primaryColor: foregroundColor, isElevated: false),
      child: text);
}

ButtonStyle getCommonButtonStyle({Color primaryColor = colorGreen, Color? secondaryColor = colorWhite, bool isElevated = true}) {
  return ElevatedButton.styleFrom(
          backgroundColor: isElevated ? primaryColor : Colors.transparent,
          foregroundColor: isElevated ? secondaryColor : primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));
}

FloatingActionButton floatingActionButtonWithText(String label, IconData icon, Function() action) {
  return FloatingActionButton.extended(
        foregroundColor: colorWhite,
        backgroundColor: colorGreen,
        label: Text(label),
        icon: Icon(icon),
        onPressed: action);
}

Future<void> pushScreen(context, screen, {replace = false, root = false}) {
  MaterialPageRoute route = MaterialPageRoute(builder: (context) => screen);

  if (replace) {
    return Navigator.of(context, rootNavigator: root).pushReplacement(route);
  }
  else {
    return Navigator.of(context, rootNavigator: root).push(route);
  }
}

// Returns the first 'count' of authors stylistically.
String printFirstAuthors(var authorList, int count) {
  var authors = authorList.take(count);
  return authors.length < count
    ? authors.join(", ")
    : "${authors.join(", ")}, and more";
}

SystemUiOverlayStyle defaultOverlay([Color? color, bool light = true]) {
  return SystemUiOverlayStyle(
    // Status bar color
    statusBarColor: color ?? colorGreen,

    // Status bar icon brightness
    // For Android
    statusBarIconBrightness: light == true ? Brightness.light : Brightness.dark,

    // For iOS
    statusBarBrightness:  light == true ? Brightness.light : Brightness.dark,
  );
}

String convertStringToDateString(String str) {
  List<String> parsedDate = str.split('/');
  return "${parsedDate[2]}-${parsedDate[0].padLeft(2, '0')}-${parsedDate[1].padLeft(2, '0')}";
}

String convertDateToString(DateTime date) {
  return "${date.month}/${date.day}/${date.year}";
}

DateTime convertStringToDate(String str) {
  return DateTime.parse(convertStringToDateString(str));
}

int getMonthFromDateString(String str) {
  return int.parse(str.substring(5,7));
}

int getYearFromDateString(String str) {
  return int.parse(str.substring(0,4));
}

dynamic resultAlert(BuildContext context, Result result, [bool pop=true]) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: result.color ?? (result.isSuccess ? colorGreenDark : colorRed),
        content: Row(
          children: [
            Text(
              result.message, 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Icon(
              result.isSuccess ? Icons.check_circle_outline_rounded : Icons.error_outline, 
              color: Colors.white
            )
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    if (pop) {
      Navigator.pop(context);
    }
  }
}

dynamic parseProgress(int progress) {
  String s = progress.toString();
  if (s.length <= 3) {
    return [0, progress];
  }
  int splitIndex = s.length - 3;
  return [int.parse(s.substring(0, splitIndex)), int.parse(s.substring(splitIndex))];
}
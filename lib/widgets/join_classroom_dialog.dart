import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/action_result.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

dynamic joinClassDialog(BuildContext context, TextTheme textTheme, int childId) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    TextEditingController textEditingController = TextEditingController();

    return showDialog(
        context: context,
        builder: (BuildContext context)
    {

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
                    inactiveColor: colorGreenLessLight,
                    activeColor: colorGreen,
                    selectedColor: colorGreen,
                  ),
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
                textEditingController.value.text.length != 6 ? null : () async {
                Result result = await appState.joinChildClassroom(childId, textEditingController.value.text);
                if (context.mounted) {
                  resultAlert(context, result);
                }
              })
          ],
        );
      });
    });
  }
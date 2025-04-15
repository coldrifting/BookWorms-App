import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/action_result.dart';
import 'package:bookworms_app/resources/theme.dart';
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
                Icon(Icons.school, color: context.colors.primary, size: 36),
                Text(
                  'Join Class',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: context.colors.primary),
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
                  cursorColor: context.colors.primary,
                  pastedTextStyle: TextStyle(color: context.colors.primaryVariant, fontWeight: FontWeight.bold),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 40,
                    fieldWidth: 35,
                    inactiveColor: context.colors.primaryVariant,
                    activeColor: context.colors.primary,
                    selectedColor: context.colors.primary,
                  ),
                ),
                Text("Need help? Ask your teacher!")
              ],
            ),
          ),
          actions: [
            dialogButton(
                context,
                "Cancel",
                () => Navigator.of(context).pop(),
                foregroundColor: context.colors.greyDark,
                isElevated: false),
            dialogButton(
                context,
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
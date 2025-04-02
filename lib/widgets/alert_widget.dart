import 'package:bookworms_app/resources/colors.dart';

import 'package:flutter/material.dart';

/// [AlertWidget] is used for displaying an alert with a title, message body,
/// and confirm / cancel buttons.
class AlertWidget extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final Color confirmColor;
  final Color cancelColor;
  final String cancelText;
  final VoidCallback? action;
  final VoidCallback? cancelAction;
  final bool popOnCancel;
  final bool popOnConfirm;

  const AlertWidget(
      {super.key,
      required this.title,
      required this.message,
      required this.confirmText,
      required this.cancelText,
      this.cancelColor = colorRed,
      this.confirmColor = colorGreenDark,
      this.action,
      this.cancelAction,
      this.popOnConfirm = true,
      this.popOnCancel = true});

  @override
  State<AlertWidget> createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  @override
  Widget build(BuildContext context) {
    NavigatorState navState = Navigator.of(context);
    return AlertDialog(
      title: Center(child: Text(widget.title, textAlign: TextAlign.center)),
      content: Text(widget.message, textAlign: TextAlign.center,),
      actions: [
        TextButton(
          onPressed: () {
            widget.cancelAction?.call();
            if (widget.popOnCancel) {
              Navigator.of(context).pop();
            }
          },
          child: Text(widget.cancelText,
              style: TextStyle(color: widget.cancelColor)),
        ),
        TextButton(
          onPressed: () {
            widget.action?.call();
            if (widget.popOnConfirm) {
              Navigator.of(context).pop();
            }
          },
          child: Text(
            widget.confirmText,
            style: TextStyle(color: widget.confirmColor),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

/// [AlertWidget] is used for displaying an alert with a title, message body,
/// and confirm / cancel buttons.
class AlertWidget extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final Color confirmColor;
  final String cancelText;
  final VoidCallback action;

  const AlertWidget({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.confirmColor,
    required this.cancelText,
    required this.action
  });

  @override
  State<AlertWidget> createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(widget.title)),
      content: Text(widget.message),
      actions: [
        TextButton(
          onPressed: () { Navigator.of(context).pop(); },
          child: Text(widget.cancelText),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.action();
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
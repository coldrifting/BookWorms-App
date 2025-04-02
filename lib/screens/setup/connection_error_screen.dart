import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/screens/setup/ping_screen.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';

import 'package:bookworms_app/widgets/alert_widget.dart';
import 'package:flutter/services.dart';

class ConnectionErrorScreen extends StatefulWidget {
  const ConnectionErrorScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ConnectionErrorScreen();
}

class _ConnectionErrorScreen extends State<ConnectionErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
                decoration: splashGradient(),
                child: AlertWidget(
                    title: "Connection Error",
                    message: "Unable to connect to the bookworms server.\r\n"
                        "Current URL: $serverBaseUri \r\n"
                        "If URL is valid, check console for CORS issues.",
                    confirmText: "Retry",
                    cancelText: "Exit",
                    popOnCancel: false,
                    popOnConfirm: false,
                    action: () {
                      pushScreen(context, const PingScreen(), replace: true);
                    },
                    cancelAction: () {
                      // Exit App
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    }))));
  }
}

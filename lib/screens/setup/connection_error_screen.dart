import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/screens/setup/splash_screen.dart';
import 'package:bookworms_app/services/auth_storage.dart';
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
                    message: "Unable to connect to server\r\n"
                        "URL: $serverBaseUri \r\n\r\n"
                        "If URL appears valid, \r\ncheck console for CORS issues.",
                    confirmText: "Retry",
                    cancelText: "Exit",
                    popOnCancel: false,
                    popOnConfirm: false,
                    action: () {
                      deleteToken();
                      pushScreen(context, const SplashScreen(), replace: true);
                    },
                    cancelAction: () {
                      // Exit App
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    }))));
  }
}

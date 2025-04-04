import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/screens/setup/splash_screen.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class ConnectionErrorScreen extends StatefulWidget {
  const ConnectionErrorScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ConnectionErrorScreen();
}

class _ConnectionErrorScreen extends State<ConnectionErrorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showAlert(context));
  }

  Future<void> _showAlert(context) async {
    bool result = await showConfirmDialog(
        context,
        "Connection Error",
        "Unable to connect to server\r\n"
            "URL: $serverBaseUri \r\n\r\n"
            "If URL appears valid, \r\ncheck console for CORS issues.",
        confirmText: "Retry",
        cancelText: "Exit",
        cancelColor: colorRed);

    if (result) {
      pushScreen(context, const SplashScreen(), replace: true);
    } else {
      // Exit the app
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
              decoration: splashGradient(),
            )));
  }
}

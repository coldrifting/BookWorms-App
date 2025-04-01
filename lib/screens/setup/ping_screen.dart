import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/screens/setup/connection_error_screen.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';

import 'package:bookworms_app/screens/setup/welcome_screen.dart';
import 'package:bookworms_app/services/account/ping_service.dart';
import 'package:flutter/services.dart';

class PingScreen extends StatefulWidget {
  const PingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PingScreen();
}

class _PingScreen extends State<PingScreen> {
  @override
  void initState() {
    super.initState();
    _ping();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
                decoration: splashGradient(),
                child: Center(
                    child: CircularProgressIndicator(color: colorWhite)))));
  }

  Future<void> _ping() async {
    PingService pingService = PingService();
    bool valid = await pingService.ping();
    if (mounted) {
      if (valid) {
        pushScreen(context, const WelcomeScreen(), replace: true);
      } else {
        pushScreen(context, const ConnectionErrorScreen(), replace: true);
      }
    }
  }
}

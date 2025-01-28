import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SetupBackdropWidget extends StatelessWidget {
  final Widget childWidget;

  const SetupBackdropWidget({
    required this.childWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    height: 155,
                    child: SvgPicture.asset(
                      'assets/images/setup_curve_top.svg',
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: SvgPicture.asset(
                      'assets/images/bookworms_logo.svg',
                      width: 125,
                      semanticsLabel: "BookWorms Logo",
                    ),
                  ),
                ],
              ),
              Spacer(),
              childWidget,
              Spacer(),
              SizedBox(
                height: 155,
                child: SvgPicture.asset(
                  'assets/images/setup_curve_bottom.svg',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
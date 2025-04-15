import 'package:bookworms_app/resources/theme.dart';
import 'package:flutter/foundation.dart';
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
    // Since `MediaQueryData.viewInsets.bottom` is most times zero,
  // and since `WidgetsBinding.instance.window` is deprecated.
  var window = PlatformDispatcher.instance.views.first;

  // Then since `EdgeInsets.fromWindowPadding` is deprecated.
  final viewInsets = EdgeInsets.fromViewPadding(
    window.viewInsets,
    window.devicePixelRatio,
  );

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
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/images/setup_curve_top_bg.svg',
                            colorFilter: Theme.of(context).brightness == Brightness.dark
                                ? ColorFilter.mode(context.colors.primaryVariant, BlendMode.srcIn)
                                : null
                          ),
                          SvgPicture.asset(
                            'assets/images/setup_curve_top_fg.svg',
                            colorFilter: Theme.of(context).brightness == Brightness.dark
                                ? ColorFilter.mode(context.colors.primary, BlendMode.srcIn)
                                : null
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 200,
                    child: SvgPicture.asset(
                      'assets/images/bookworms_logo.svg',
                      width: 125,
                      semanticsLabel: "BookWorms Logo"
                    ),
                  ),
                ],
              ),
              Spacer(),
              childWidget,
              Spacer(),
              SizedBox(
                height: 155,
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/images/setup_curve_bottom_fg.svg',
                      colorFilter: Theme.of(context).brightness == Brightness.dark
                          ? ColorFilter.mode(context.colors.primaryVariant, BlendMode.srcIn)
                          : null
                    ),
                    SvgPicture.asset(
                      'assets/images/setup_curve_bottom_bg.svg',
                      colorFilter: Theme.of(context).brightness == Brightness.dark
                          ? ColorFilter.mode(context.colors.primary, BlendMode.srcIn)
                          : null,
                  )
                  ],
                ),
              ),
              // Move Button into view when soft keyboard is shown
              SizedBox(
                height: (viewInsets.bottom * 3),
              )
            ],
          ),
        ),
      ),
    );
  }
}
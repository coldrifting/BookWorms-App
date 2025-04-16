import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    var width = MediaQuery.of(context).size.width;
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: isDarkMode
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            child: Container(
                // Make scroll edges consistent with content at edges
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      context.colors.swoopTopFg,
                      context.colors.swoopBottomBg,
                    ],
                    stops: [0.49, 0.51],
                  ),
                ),
                child: SingleChildScrollView(
                    child: Container(
                  color: context.colors.surface,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        color: context.colors.swoopTopFg,
                      ),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Stack(
                            children: [
                              SvgPicture.asset(
                                  'assets/images/setup_curve_top_bg.svg',
                                  width: width,
                                  fit: BoxFit.fitWidth,
                                  colorFilter: ColorFilter.mode(
                                      context.colors.swoopTopBg,
                                      BlendMode.srcIn)),
                              SvgPicture.asset(
                                  'assets/images/setup_curve_top_fg.svg',
                                  width: width,
                                  fit: BoxFit.fitWidth,
                                  colorFilter: ColorFilter.mode(
                                      context.colors.swoopTopFg,
                                      BlendMode.srcIn)),
                            ],
                          ),
                          Column(
                            children: [
                              addVerticalSpace(24),
                              SvgPicture.asset(
                                  width: 125,
                                  'assets/images/bookworms_logo.svg',
                                  alignment: AlignmentDirectional.topCenter)
                            ],
                          ),
                        ],
                      ),
                      if (viewInsets.bottom == 0) Spacer(flex: 2),
                      childWidget,
                      Spacer(flex: 1),
                      Stack(
                        children: [
                          SvgPicture.asset(
                              'assets/images/setup_curve_bottom_fg.svg',
                              width: width,
                              fit: BoxFit.fitWidth,
                              colorFilter: ColorFilter.mode(
                                  context.colors.swoopBottomFg,
                                  BlendMode.srcIn)),
                          SvgPicture.asset(
                              'assets/images/setup_curve_bottom_bg.svg',
                              width: width,
                              fit: BoxFit.fitWidth,
                              colorFilter: ColorFilter.mode(
                                  context.colors.swoopBottomBg,
                                  BlendMode.srcIn)),
                        ],
                      ),
                    ],
                  ),
                )))));
  }
}

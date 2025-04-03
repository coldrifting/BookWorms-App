import 'package:bookworms_app/showcase/showcase_controller.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class BWShowcase extends StatefulWidget {
  final GlobalKey showcaseKey;
  final Widget child;
  final String? title;
  final String? description;
  final ShapeBorder targetShapeBorder;
  final BorderRadius? tooltipBorderRadius;
  final bool showArrow;
  final bool? disableMovingAnimation;
  final List<String>? tooltipActions;
  final int? toScreen;
  final int? fromScreen;

  const BWShowcase({
    super.key,
    required this.showcaseKey,
    required this.child,
    this.title,
    this.description,
    this.targetShapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    this.tooltipBorderRadius,
    this.showArrow = true,
    this.disableMovingAnimation = false,
    this.tooltipActions,
    this.toScreen,
    this.fromScreen
  });

  @override
  State<StatefulWidget> createState() => _BWShowcaseState();
}

class _BWShowcaseState extends State<BWShowcase> {
  late final showcaseController = ShowcaseController();

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: widget.showcaseKey,
      title: widget.title,
      description: widget.description,
      descTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      descriptionTextAlign: TextAlign.center,
      targetShapeBorder: widget.targetShapeBorder,
      targetBorderRadius: widget.tooltipBorderRadius,
      tooltipActions: widget.tooltipActions
          ?.map((name) =>
              _actionButtonFromName(name, widget.toScreen, widget.fromScreen))
          .toList(),
      tooltipPadding: const EdgeInsets.all(25),
      tooltipActionConfig: widget.tooltipActions == null
        ? null
        : const TooltipActionConfig(
            alignment: MainAxisAlignment.spaceBetween,
            position: TooltipActionPosition.outside,
            gapBetweenContentAndAction: 10
          ),
      disableMovingAnimation: widget.disableMovingAnimation,
      showArrow: widget.showArrow,
      child: widget.child,
    );
  }

  TooltipActionButton _actionButtonFromName(
      String name, int? toScreen, int? fromScreen) {
    switch (name) {
      case "Next":
      case "Get Started":
        return _nextButton(name, toScreen);
      case "Previous":
      case "Back":
        return _prevButton(name, fromScreen);
      case "Skip tutorial":
        return _dismissButton(name);
      default:
        return _nextButton(name, toScreen);
    }
  }

  TooltipActionButton _nextButton(String name, int? toScreen) {
    return TooltipActionButton(
        type: TooltipDefaultActionType.next,
        name: name,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        textStyle: TextStyle(color: Colors.white),
        onTap: () {
          if (toScreen != null) showcaseController.navigate!.call(toScreen);
          showcaseController.next();
        }
    );
  }

  TooltipActionButton _prevButton(String name, int? fromScreen) {
    return TooltipActionButton(
        type: TooltipDefaultActionType.previous,
        name: name,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        backgroundColor: Colors.transparent,
        textStyle: TextStyle(color: Colors.white),
        onTap: () {
          if (fromScreen != null) showcaseController.navigate!.call(fromScreen);
          showcaseController.previous();
        }
    );
  }

  TooltipActionButton _dismissButton(String name) {
    return TooltipActionButton(
        type: TooltipDefaultActionType.skip,
        name: name,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        backgroundColor: Colors.transparent,
        textStyle: TextStyle(color: Colors.white),
        onTap: showcaseController.dismiss
    );
  }

}
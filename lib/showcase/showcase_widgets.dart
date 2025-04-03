import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/showcase/showcase_controller.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class BWShowcase extends StatefulWidget {
  final GlobalKey showcaseKey;
  final Widget child;
  final String? title;
  final String? description;
  final EdgeInsets? targetPadding;
  final ShapeBorder targetShapeBorder;
  final BorderRadius? tooltipBorderRadius;
  final bool showArrow;
  final bool? disableMovingAnimation;
  final List<String>? tooltipActions;
  final MainAxisAlignment? tooltipAlignment;
  final TooltipPosition? tooltipPosition;
  final int? toScreen;

  const BWShowcase({
    super.key,
    required this.showcaseKey,
    required this.child,
    this.title,
    this.description,
    this.targetPadding,
    this.targetShapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    this.tooltipBorderRadius,
    this.showArrow = true,
    this.disableMovingAnimation = false,
    this.tooltipActions,
    this.tooltipAlignment,
    this.tooltipPosition,
    this.toScreen
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
      targetPadding: widget.targetPadding ?? EdgeInsets.zero,
      targetShapeBorder: widget.targetShapeBorder,
      targetBorderRadius: widget.tooltipBorderRadius,
      onTargetClick: widget.toScreen == null ? null : () {
        showcaseController.goToScreen(widget.toScreen!);
        showcaseController.next();
      },
      onBarrierClick: showcaseController.skipToEnd,
      disposeOnTap: widget.toScreen == null ? null : false,
      tooltipActions: widget.tooltipActions
          ?.map((name) =>
              _actionButtonFromName(name, widget.toScreen))
          .toList(),
      tooltipPadding: const EdgeInsets.all(25),
      tooltipActionConfig: widget.tooltipActions == null
        ? null
        : TooltipActionConfig(
            alignment: widget.tooltipAlignment ?? MainAxisAlignment.spaceBetween,
            position: TooltipActionPosition.outside,
            gapBetweenContentAndAction: 10
          ),
      tooltipPosition: widget.tooltipPosition,
      disableMovingAnimation: widget.disableMovingAnimation,
      showArrow: widget.showArrow,
      child: widget.child,
    );
  }

  TooltipActionButton _actionButtonFromName(String name, int? toScreen) {
    switch (name) {
      case "Next":
      case "Get Started":
        return _nextButton(name, toScreen);
      case "Previous":
      case "Back":
        return _prevButton(name, toScreen);
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
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        backgroundColor: colorGreen,
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        onTap: () {
          if (toScreen != null) showcaseController.goToScreen(toScreen);
          showcaseController.next();
        }
    );
  }

  TooltipActionButton _prevButton(String name, int? toScreen) {
    return TooltipActionButton(
        type: TooltipDefaultActionType.previous,
        name: name,
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        backgroundColor: Colors.transparent,
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        onTap: () {
          if (toScreen != null) {
            int fromScreen = showcaseController.getPreviousScreenIndex(toScreen);
            showcaseController.goToScreen(fromScreen);
          }
          showcaseController.previous();
        }
    );
  }

  TooltipActionButton _dismissButton(String name) {
    return TooltipActionButton(
        type: TooltipDefaultActionType.skip,
        name: name,
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        backgroundColor: Colors.transparent,
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        onTap: showcaseController.dismiss
    );
  }

}
import 'package:bookworms_app/resources/theme.dart';
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
  final TooltipActionSet tooltipActions;
  final MainAxisAlignment? tooltipAlignment;
  final TooltipPosition? tooltipPosition;
  final double scrollAlignment;
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
    this.tooltipActions = TooltipActionSet.basic,
    this.tooltipAlignment,
    this.tooltipPosition,
    this.scrollAlignment = 0.5,
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
      descTextStyle: TextStyle(color: context.colors.onSurface, fontSize: 15, fontWeight: FontWeight.w500),
      descriptionTextAlign: TextAlign.center,
      targetPadding: widget.targetPadding ?? EdgeInsets.zero,
      targetShapeBorder: widget.targetShapeBorder,
      targetBorderRadius: widget.tooltipBorderRadius,
      onTargetClick: widget.toScreen == null ? null : () {
        showcaseController.goToScreen(widget.toScreen!);
        showcaseController.next();
      },
      disableBarrierInteraction: widget.toScreen != null && widget.toScreen != 0,
      disposeOnTap: widget.toScreen == null ? null : false,
      tooltipActions: _getActionButtons(widget.tooltipActions, widget.toScreen),
      tooltipPadding: const EdgeInsets.all(25),
      tooltipActionConfig: TooltipActionConfig(
          alignment: widget.tooltipAlignment ?? MainAxisAlignment.spaceBetween,
          position: TooltipActionPosition.outside,
          gapBetweenContentAndAction: 6
        ),
      tooltipBackgroundColor: context.colors.surface,
      tooltipPosition: widget.tooltipPosition,
      disableMovingAnimation: widget.disableMovingAnimation,
      showArrow: widget.showArrow,
      scrollAlignment: widget.scrollAlignment,
      child: widget.child,
    );
  }


  List<TooltipActionButton> _getActionButtons(TooltipActionSet actionSet, int? toScreen) {
    switch (actionSet) {
      case TooltipActionSet.start:
        return [
          _skipButton(),
          _startButton()
        ];
      case TooltipActionSet.basic:
        return [
          _dismissButton(),
          _spacerButton(),
          _spacerButton(),
          _prevButton(toScreen),
          _nextButton(toScreen)
        ];
      case TooltipActionSet.noPrev:
        return [
          _dismissButton(),
          _nextButton(toScreen)
        ];
      case TooltipActionSet.none:
        return [];
    }
  }

  TooltipActionButton _startButton() {
    return TooltipActionButton(
        type: TooltipDefaultActionType.next,
        name: "Get Started",
        tailIcon: ActionButtonIcon(
            icon: Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 16
            )
        ),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        backgroundColor: context.colors.primary,
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        onTap: showcaseController.next
    );
  }

  TooltipActionButton _skipButton() {
    return TooltipActionButton(
        type: TooltipDefaultActionType.next,
        name: "Skip Tutorial",
        tailIcon: ActionButtonIcon(
            icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 16
            )
        ),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        backgroundColor: Colors.transparent,
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        onTap: showcaseController.dismiss
    );
  }

  TooltipActionButton _nextButton(int? toScreen) {
    return TooltipActionButton(
        type: TooltipDefaultActionType.next,
        name: "",
        tailIcon: ActionButtonIcon(
            icon: Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 24
            )
        ),
        padding: const EdgeInsets.fromLTRB(0, 5, 4, 5),
        backgroundColor: context.colors.primary,
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        onTap: () {
          if (toScreen != null) showcaseController.goToScreen(toScreen);
          showcaseController.next();
        }
    );
  }

  TooltipActionButton _prevButton(int? toScreen) {
    return TooltipActionButton(
        type: TooltipDefaultActionType.previous,
        name: "",
        tailIcon: ActionButtonIcon(
            icon: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 24
            )
        ),
        padding: const EdgeInsets.fromLTRB(0, 5, 4, 5),
        backgroundColor: context.colors.primary,
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

  TooltipActionButton _spacerButton() {
    return TooltipActionButton(
        type: TooltipDefaultActionType.next,
        name: "Spacer",
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        backgroundColor: Colors.transparent,
        textStyle: TextStyle(color: Colors.transparent),
        onTap: () {}
    );
  }

  TooltipActionButton _dismissButton() {
    return TooltipActionButton(
        type: TooltipDefaultActionType.skip,
        name: "",
        tailIcon: ActionButtonIcon(
            icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 24
            )
        ),
        padding: const EdgeInsets.fromLTRB(0, 5, 4, 5),
        backgroundColor: Colors.transparent,
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        onTap: showcaseController.dismiss
    );
  }
}

enum TooltipActionSet {
  start,
  basic,
  noPrev,
  none
}
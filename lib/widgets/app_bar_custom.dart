import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/change_child_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final bool isLeafPage;
  final bool isChildSwitcherEnabled;
  final Function()? onBackBtnPressed;

  const AppBarCustom(
      this.title, {
    this.isLeafPage = true,
        this.onBackBtnPressed,
        this.isChildSwitcherEnabled = false,
        this.centerTitle = false,
        super.key});

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);

    return AppBar(
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorWhite,
                overflow: TextOverflow.ellipsis)),
        centerTitle: centerTitle,
        backgroundColor: colorGreen,
        systemOverlayStyle: defaultOverlay(),
        leading: isLeafPage
            ? IconButton(
                color: colorWhite,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  onBackBtnPressed?.call();
                  if (onBackBtnPressed == null) {
                    Navigator.of(context).pop();
                  }
                })
            : null,
    actions: [
      isChildSwitcherEnabled && appState.isParent
          ? ChangeChildWidget(onChildChanged: () {
            while (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          })
          : SizedBox.shrink()
    ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

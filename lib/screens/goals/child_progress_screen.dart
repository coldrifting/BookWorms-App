import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/screens/goals/goals_screen.dart';
import 'package:bookworms_app/showcase/showcase_controller.dart';
import 'package:bookworms_app/showcase/showcase_widgets.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:bookworms_app/widgets/child_selection_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The [ProgressScreen] contains information about the selected child's
/// progress toward their set custom goals.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

/// The state of the [ProgressScreen].
class _ProgressScreenState extends State<ProgressScreen> {
  late final showcaseController = ShowcaseController();
  late final List<GlobalKey> navKeys = showcaseController.getKeysForScreen('progress');

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    AppState appState = Provider.of<AppState>(context);
    Child selectedChild = appState.children[appState.selectedChildID];

    return Scaffold(
      appBar: AppBarCustom("${selectedChild.name}'s Progress", isLeafPage: false),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => showChildSelection(selectedChild),
              child: Column(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: UserIcons.getIcon(selectedChild.profilePictureIndex),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          style: textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                          selectedChild.name
                        ),
                        const Icon(size: 35, Icons.arrow_drop_down_sharp),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(style: textTheme.bodyLarge, "Reading Level: A"),
            const Divider(),
            // Overall progress and Goal progress tabs.
            _tabBar(),
          ],
        ),
      ),
    );
  }

  // Tab bar for switching between overall progress and goal progress.
  Widget _tabBar() {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                BWShowcase(
                  showcaseKey: navKeys[0],
                  description: "[Description of Overall Progress]",
                  targetPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  tooltipActions: ["Previous", "Next"],
                  child: Tab(text: "Overall Progress")
                ),
                BWShowcase(
                  showcaseKey: navKeys[1],
                  description: "Switch to \"Goal Progress\" to make and track goals for your child",
                  targetPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  tooltipActions: ["Previous", "Next"],
                  child: Tab(text: "Goal Progress")
                ),
              ],
              unselectedLabelColor: colorGrey,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text("Overall Progress")),
                  Center(child: GoalsScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pulls up the list of children to change the view.
  void showChildSelection(Child selectedChild) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ChildSelectionListWidget();
      },
    );
  }
}

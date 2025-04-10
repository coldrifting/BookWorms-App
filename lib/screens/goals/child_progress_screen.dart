import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/screens/goals/goals_screen.dart';
import 'package:bookworms_app/screens/goals/progress_overview_screen.dart';
import 'package:bookworms_app/showcase/showcase_controller.dart';
import 'package:bookworms_app/showcase/showcase_widgets.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/announcements_widget.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:bookworms_app/widgets/child_selection_list_widget.dart';
import 'package:bookworms_app/widgets/reading_level_info_widget.dart';
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
      appBar: AppBarCustom("${selectedChild.name}'s Progress", isLeafPage: false, rightAction: AnnouncementsWidget()),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // Icon Header.
            SliverToBoxAdapter(
              child: _header()
            ),

            // Pinned icon header (name and reading level).
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverDelegate(
                child: _pinnedHeader(textTheme, selectedChild)
              ),
            ),

            // Tab bar.
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _SliverDelegate(
                child: TabBar(
                  labelStyle: textTheme.labelLarge,
                  labelColor: colorGreen,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: colorGreen,
                  tabs: [
                    BWShowcase(
                      showcaseKey: navKeys[0],
                      description: "Visit \"Overall Progress\" to see your child's reading progress over time",
                      targetPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Tab(text: "Overall Progress")
                    ),
                    BWShowcase(
                      showcaseKey: navKeys[1],
                      description: "Switch to \"Goal Progress\" to make and track goals for your child",
                      targetPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Tab(text: "Goal Progress")
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              ProgressOverviewScreen(selectedChild: selectedChild),
              GoalsScreen()
            ],
          ),
        ),
      ),
    );
  }

  Widget _pinnedHeader(TextTheme textTheme, Child selectedChild) {
    return Column(
      children: [
        addVerticalSpace(4),
        Text(
          style: textTheme.headlineMedium,
          textAlign: TextAlign.center,
          selectedChild.name
        ),
        SizedBox(
          width: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Centered reading level text
              Text(
                "Reading Level: ${selectedChild.readingLevel ?? "N/A "}",
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),

              // Right-side question mark button
              Positioned(
                right: -5,
                child: RawMaterialButton(
                  onPressed: () => pushScreen(context, const ReadingLevelInfoWidget(forBook: false)),
                  shape: const CircleBorder(),
                  constraints: const BoxConstraints.tightFor(width: 30, height: 30),
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    Icons.help_outline,
                    color: colorBlack,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header() {
    AppState appState = Provider.of<AppState>(context);
    Child selectedChild = appState.children[appState.selectedChildID];

    return Container(
      color: colorWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            addVerticalSpace(16),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      InkWell(
                        onTap: () => showChildSelection(selectedChild),
                        child: Container(
                          width: 115,
                          height: 115,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: colorGreyDark, width: 2)
                          ),
                          child: UserIcons.getIcon(selectedChild.profilePictureIndex, 100),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

// Custom SliverPersistentHeaderDelegate to manage the behavior and layout of the pinned
// classroom title and TabBar. It is responsible for building the widgets, defining their
// height, and ensuring that they remain pinned at the top of the screen.
class _SliverDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverDelegate({required this.child});

  @override
  double get minExtent => child is TabBar ? (child as TabBar).preferredSize.height : 80.0;
  @override
  double get maxExtent => child is TabBar ? (child as TabBar).preferredSize.height : 80.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: colorWhite,
      elevation: 1,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverDelegate oldDelegate) {
    return true;
  }
}

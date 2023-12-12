import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

class BottomNavigationPageController extends Cubit<int> {
  late PageController controller;
  BottomNavigationPageController(super.initialState) {
    controller = PageController(initialPage: state, keepPage: false);
    controller.addListener(
        () => emit(controller.hasClients ? controller.page!.round() : state));
  }
  index(int index) => controller.go(index);

  refresh() => controller.hasClients ? controller.jumpToPage(state) : null;
}

class BottomNavigationPage extends StatefulWidget {
  final int initialIndex;
  final List<Widget>? drawerItems;
  final Widget drawerHeader;

  final List<BottomNavigationView> views;
  const BottomNavigationPage({
    required this.initialIndex,
    required this.views,
    this.drawerHeader = const SizedBox.shrink(),
    this.drawerItems,
    super.key,
  });

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage>
    with AutomaticKeepAliveClientMixin {
  late final BottomNavigationPageController controller;

  final Key _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = BottomNavigationPageController(widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (c) => controller,
      child: BlocBuilder<BottomNavigationPageController, int>(
        builder: (context, state) {
          return ScaffoldWidget(
            title: widget.views[state].title,
            actions: widget.views[state].actions,
            primaryButton: widget.views[state].primaryButton,
            body: PageView(
              key: _key,
              scrollDirection:
                  context.mediaQuery.orientation == Orientation.portrait
                      ? Axis.horizontal
                      : Axis.vertical,
              controller: controller.controller,
              physics: const NeverScrollableScrollPhysics(),
              children: widget.views.map((e) => e.view).toList(),
            ),
            drawerHeader: widget.drawerHeader,
            drawerItems: widget.drawerItems,
            navigationBarData: NavigationBarData(
              currentIndex: state,
              items: widget.views.map((e) => e.navigationBarItem).toList(),
              onChange: controller.index,
            ),
            //drawerItems: const [Center(child: AnimatedLogo())],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

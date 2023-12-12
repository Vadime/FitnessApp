import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class CardWidget extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding, margin;
  final Color? backgroundColor;
  final dynamic Function()? onTap;
  final CrossAxisAlignment crossAxisAlignment;
  final double? radius;
  final double? maxWidth;
  final List<Widget>? slideMenuItems;
  const CardWidget({
    required this.children,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.backgroundColor,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.onTap,
    this.radius,
    this.maxWidth,
    this.slideMenuItems,
    super.key,
  });

  factory CardWidget.single({
    required Widget child,
    double? radius,
    EdgeInsets padding = const EdgeInsets.all(0),
    EdgeInsets margin = const EdgeInsets.all(0),
    Color? backgroundColor,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.stretch,
    Key? key,
    dynamic Function()? onTap,
    double? maxWidth,
    List<Widget>? slideMenuItems,
  }) =>
      CardWidget(
        slideMenuItems: slideMenuItems,
        padding: padding,
        margin: margin,
        key: key,
        onTap: onTap,
        crossAxisAlignment: crossAxisAlignment,
        backgroundColor: backgroundColor,
        maxWidth: maxWidth,
        children: [child],
      );

  @override
  Widget build(BuildContext context) {
    if (maxWidth == null) {
      return _build(context);
    } else {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth!),
          child: _build(context),
        ),
      );
    }
  }

  _build(BuildContext context) => Padding(
        padding: margin,
        child: SlideMenu(menuItems: slideMenuItems, child: _inkwell(context)),
      );

  Widget _inkwell(BuildContext context) => Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? context.config.radius),
      ),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(context.config.radius),
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          ),
        ),
      ));
}

class SlideMenu extends StatefulWidget {
  final Widget child;
  final List<Widget>? menuItems;

  const SlideMenu({super.key, required this.child, required this.menuItems});

  @override
  SlideMenuState createState() => SlideMenuState();
}

class SlideMenuState extends State<SlideMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<Offset>? animation;
  @override
  initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animation = Tween(
              begin: const Offset(0.0, 0.0),
              end: Offset(-90 / (context.size?.width ?? 1), 0.0))
          .animate(CurveTween(curve: Curves.decelerate).animate(_controller));
      setState(() {});
    });
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.menuItems == null) return widget.child;

    return GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          _controller.value -=
              (data.primaryDelta ?? 0) / (context.size?.width ?? 1);
        });
      },
      onHorizontalDragEnd: (data) {
        if ((data.primaryVelocity ?? 0) > 2500) {
          _controller
              .animateTo(.0); //close menu on fast swipe in the right direction
        } else if (_controller.value >= .5 ||
            (data.primaryVelocity ?? 0) <
                -2500) // fully open if dragged a lot to left or on fast swipe to left
        {
          _controller.animateTo(1.0);
        } else // close if none of above
        {
          _controller.animateTo(.0);
        }
      },
      child: Stack(
        children: <Widget>[
          if (animation != null)
            SlideTransition(position: animation!, child: widget.child)
          else
            widget.child,
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraint) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                          right: .0,
                          top: .0,
                          bottom: .0,
                          width: (constraint.maxWidth *
                                  (animation?.value.dx ?? 1) *
                                  -1) -
                              context.config.paddingH,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(context.config.radius),
                            child: Container(
                              color: context.config.neutralColor,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: widget.menuItems!.map((child) {
                                  return Expanded(
                                    child: child,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class SlideMenuItem extends StatelessWidget {
  final Widget child;
  final Color? color;
  final dynamic Function()? onTap;
  const SlideMenuItem({required this.child, this.onTap, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (onTap is Future Function()) {
          LoadingController().loadingProcess(onTap);
        } else {
          onTap?.call();
        }
      },
      borderRadius: BorderRadius.circular(context.config.radius),
      child: Container(
        color: color,
        padding: const EdgeInsets.all(10),
        child: Center(child: child),
      ),
    );
  }
}

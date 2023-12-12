import 'package:flutter/material.dart';
import 'package:widgets/utils/utils.dart';

class PageIndicatorWidget extends StatefulWidget {
  final PageController controller;
  final int pageCount;
  final Color foregroundColor;
  const PageIndicatorWidget({
    required this.controller,
    required this.pageCount,
    this.foregroundColor = Colors.white,
    super.key,
  });

  @override
  State<PageIndicatorWidget> createState() => _PageIndicatorWidgetState();
}

class _PageIndicatorWidgetState extends State<PageIndicatorWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (context.mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < widget.pageCount; i++)
          if (i == widget.controller.currentPage)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(2),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: widget.foregroundColor,
                shape: BoxShape.circle,
              ),
            )
          else
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(2),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: widget.foregroundColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
      ],
    );
  }
}

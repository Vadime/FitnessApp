library widgets;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

class SlidingSegmentedButton<T> extends StatelessWidget {
  final SegmentedButtonController<T> controller;
  final List<ButtonData<T>> segments;
  final EdgeInsets margin;
  final double? maxWidth;

  const SlidingSegmentedButton({
    required this.controller,
    required this.segments,
    this.margin = EdgeInsets.zero,
    this.maxWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double outerPadding = context.config.paddingH * .5;
    double innerPadding = context.config.paddingH * 1;
    return CardWidget.single(
      maxWidth: maxWidth,
      margin: margin,
      child: BlocBuilder<SegmentedButtonController<T>, T>(
        bloc: controller,
        builder: (context, state) {
          return LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                AnimatedPositioned(
                  left: (constraints.maxWidth / segments.length) *
                          segments.indexWhere((e) => e.value == state) +
                      outerPadding,
                  top: 0,
                  bottom: 0,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    width: (constraints.maxWidth / segments.length) -
                        (outerPadding * 2),
                    margin: EdgeInsets.fromLTRB(
                      0,
                      outerPadding,
                      0,
                      outerPadding,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius:
                          BorderRadius.circular(context.config.radius),
                    ),
                  ),
                ),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    children: segments
                        .map((e) => GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => controller.toggle(e.value),
                              child: SizedBox(
                                width: constraints.maxWidth / segments.length,
                                child: Hero(
                                  tag: '${e.value}',
                                  child: TextWidget(
                                    e.text,
                                    color:
                                        e.value == state ? Colors.white : null,
                                    weight: e.value == state
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    align: TextAlign.center,
                                    margin: EdgeInsets.fromLTRB(
                                      innerPadding / 2,
                                      innerPadding,
                                      innerPadding / 2,
                                      innerPadding,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList()),
              ],
            );
          });
        },
      ),
    );
  }
}

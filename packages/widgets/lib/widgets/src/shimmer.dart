import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:widgets/widgets.dart';

class ShimmerWidget extends StatelessWidget {
  final Widget child;
  const ShimmerWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.config.neutralColor,
      highlightColor: Theme.of(context).highlightColor,
      direction: ShimmerDirection.ltr,
      period: const Duration(milliseconds: 600),
      child: Padding(
          padding: EdgeInsets.all(context.config.padding), child: child),
    );
  }

  // to load ListTiles
  factory ShimmerWidget.listTile() => ShimmerWidget(
        child: Builder(
          builder: (context) => ListTile(
            title: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: context.config.neutralColor,
                      borderRadius:
                          BorderRadius.circular(context.config.radius)),
                  height: 14,
                  width: 100,
                ),
                const Spacer()
              ],
            ),
            subtitle: Container(
              decoration: BoxDecoration(
                  color: context.config.neutralColor,
                  borderRadius: BorderRadius.circular(context.config.radius)),
              height: 10,
              width: 100,
              margin: const EdgeInsets.only(right: 10),
            ),
            trailing: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.config.neutralColor,
              ),
            ),
          ),
        ),
      );
  // to load Cards
  factory ShimmerWidget.card() =>
      ShimmerWidget(child: CardWidget.single(child: const SizedBox()));
}

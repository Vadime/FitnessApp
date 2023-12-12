import 'package:flutter/material.dart';

class FloatingAtionsWidget extends StatelessWidget {
  final List<Widget>? actions;
  final Widget? primaryButton;

  const FloatingAtionsWidget({
    required this.actions,
    required this.primaryButton,
    super.key,
  });

  get hasFloatingActions => actions != null && actions!.length > 1;
  get hasPrimaryButton => primaryButton != null;

  @override
  Widget build(BuildContext context) {
    if (hasFloatingActions || hasPrimaryButton) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (hasFloatingActions) ...[
                ...actions!.getRange(1, actions!.length).toList(),
              ],
              if (hasFloatingActions && hasPrimaryButton) ...[
                const SizedBox(width: 20),
              ],
              if (hasPrimaryButton) ...[
                Expanded(child: primaryButton!),
              ],
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

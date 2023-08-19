import 'package:fitnessapp/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

class ProfileThemeChangePopup extends StatelessWidget {
  const ProfileThemeChangePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Change Theme',
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          BlocBuilder<ThemeBloc, ThemeMode>(
            builder: (context, state) {
              return SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('System'),
                  ),
                  ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                  ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                ],
                selected: {state},
                onSelectionChanged: (selected) => context
                    .read<ThemeBloc>()
                    .add(ThemeEvent(mode: selected.first)),
              );
            },
          )
        ],
      ),
    );
  }
}

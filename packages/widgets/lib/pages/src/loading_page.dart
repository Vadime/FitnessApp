import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

class LoadingPage extends StatelessWidget {
  final ThemeConfig config;
  const LoadingPage(this.config, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingController, AnimatedBool>(
      bloc: LoadingController(),
      builder: (context, loading) {
        if (!loading.value && loading.completed) {
          return const SizedBox();
        } else {
          return IgnorePointer(
            ignoring: !loading.value,
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              opacity: loading.value ? 1 : 0,
              child: Container(
                color: context.config.primaryColor.withOpacity(0.3),
                child: const Directionality(
                  textDirection: TextDirection.ltr,
                  child: Center(
                    child: SizedBox.square(
                      dimension: 100,
                      child: AnimatedLogo(),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

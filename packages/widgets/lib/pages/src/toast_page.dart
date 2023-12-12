import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

class ToastPage extends StatelessWidget {
  final ThemeConfig config;
  const ToastPage(this.config, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToastController, ToastData>(
      bloc: ToastController(),
      builder: (context, state) {
        // wenn das ding nicht gezeigt werden soll und die animation fertig ist
        // dann zeig was leeres
        if ((!state.animation.value && state.animation.completed) ||
            state.message == null) {
          return const SizedBox();
        } else {
          return IgnorePointer(
            ignoring: true,
            child: AnimatedOpacity(
              duration: ToastController.animTime,
              curve: state.animation.completed ? Curves.easeIn : Curves.easeOut,
              opacity: state.animation.completed ? 1 : 0,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: config.primaryColor,
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      config.padding,
                      config.paddingH + context.topInset,
                      config.padding,
                      config.padding,
                    ),
                    child: TextWidget(
                      state.message.toString(),
                      color: Colors.white,
                      weight: FontWeight.bold,
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

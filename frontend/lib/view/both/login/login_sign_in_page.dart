library login_flow;

import 'package:fitness_app/bloc/login/login_bloc.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SignInForm(),
    );
  }
}

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Text('Sign In', style: context.textTheme.titleLarge),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              "Don't have an Account? ",
              style: context.textTheme.labelSmall,
            ),
            TextButton(
              onPressed: () =>
                  BlocProvider.of<LoginBloc>(context).add(LoginSignUpEvent()),
              child: Text(
                'Sign Up',
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                MyTextField(
                  bloc: (BlocProvider.of<LoginBloc>(context).state
                          as LoginSignInState)
                      .emailBloc,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  bloc: (BlocProvider.of<LoginBloc>(context).state
                          as LoginSignInState)
                      .passwordBloc,
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => BlocProvider.of<LoginBloc>(context)
                .add(LoginSendPasswordEvent()),
            child: Text(
              'Forgot password?',
              style: context.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.theme.primaryColor,
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

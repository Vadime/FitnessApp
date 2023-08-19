library login_flow;

import 'package:fitnessapp/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

class LoginSignUpPage extends StatelessWidget {
  const LoginSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Text('Sign Up', style: context.textTheme.titleLarge),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                'Already have an account? ',
                style: context.textTheme.labelSmall,
              ),
              TextButton(
                onPressed: () =>
                    BlocProvider.of<LoginBloc>(context).add(LoginSignInEvent()),
                child: Text(
                  'Sign In',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          CardWidget(
            children: [
              TextFieldWidget(
                (context.read<LoginBloc>().state as LoginSignUpState).emailBloc,
              ),
              TextFieldWidget(
                (context.read<LoginBloc>().state as LoginSignUpState)
                    .passwordBloc,
              ),
              TextFieldWidget(
                (context.read<LoginBloc>().state as LoginSignUpState)
                    .rPasswordBloc,
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

library login_flow;

import 'package:fitness_app/bloc/login/login_bloc.dart';
import 'package:fitness_app/utils/src/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/widgets/widgets.dart';

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
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  MyTextField(
                    bloc: (context.read<LoginBloc>().state as LoginSignUpState)
                        .emailBloc,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    bloc: (context.read<LoginBloc>().state as LoginSignUpState)
                        .passwordBloc,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    bloc: (context.read<LoginBloc>().state as LoginSignUpState)
                        .rPasswordBloc,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
